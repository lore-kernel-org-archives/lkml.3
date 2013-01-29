Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3A2Rt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:49:26 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:25036 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab3A2RtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:49:21 -0500
Message-ID: <1359481755.4144.4.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: Web10g TCP statistics patch - mainlining into kernel?
From: Ben Hutchings <bhutchings@solarflare.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <web10g-user@web10g.org>
Date: Tue, 29 Jan 2013 17:49:15 +0000
In-Reply-To: <18855.1359138716@turing-police.cc.vt.edu>
References: <18855.1359138716@turing-police.cc.vt.edu>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19594.005
X-TM-AS-Result: No--11.904200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 13:31 -0500, Valdis Kletnieks wrote:
[...]
> it's a zero-hit thing for people who don't choose to configure
> it into their kernel.
[...]

People with high-overhead changes always say this, but before long
distributions will be expected to enable it and then everyone pays the
price.  So I think you'll have to work on limiting the run-time overhead
when it's enabled at compile time but the user doesn't care about it.
Possibly it can be a run-time option?  (I haven't looked at the code and
don't expect to have time to do so.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

