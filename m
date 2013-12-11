Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346Ab3LKUot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:44:49 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:14316 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3LKUor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:44:47 -0500
Message-ID: <1386794680.1516.249.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
From: Ben Hutchings <bhutchings@solarflare.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Kalle Valo <kvalo@adurom.com>, Pavel Machek <pavel@ucw.cz>,
        "Luciano Coelho" <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <freemangordon@abv.bg>,
        <aaro.koskinen@iki.fi>, <sre@ring0.de>, <joni.lapilainen@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
Date: Wed, 11 Dec 2013 20:44:40 +0000
In-Reply-To: <201312101808.44713@pali>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	 <20131210092114.GB22756@amd.pavel.ucw.cz>
	 <8738m0r9wv.fsf@purkki.adurom.net> <201312101808.44713@pali>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20352.005
X-TM-AS-Result: No--24.113900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 18:08 +0100, Pali Rohár wrote:
> On Tuesday 10 December 2013 16:41:04 Kalle Valo wrote:
> > Pavel Machek <pavel@ucw.cz> writes:
> > > ssids can have \0s in them... and what is worse, they may
> > > not be 0 terminated AFAICT.
> > > 
> > > Potential solution is at
> > > http://www.spinics.net/lists/linux-wireless/msg98640.html .
> > 
> > I just use print_hex_dump_bytes() to print SSIDs.
> 
> Ok and has kernel printf modifier for size_t?

It is 'z', same as in userland.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

