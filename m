Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab3LJJYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:24:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43936 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LJJYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:24:40 -0500
Date: Tue, 10 Dec 2013 10:24:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2 03/16] wl1251: retry power save entry
Message-ID: <20131210092438.GC22756@amd.pavel.ucw.cz>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-4-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386494714-21070-4-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2013-12-08 10:25:01, Pali Rohár wrote:
> From: David Gnedt <david.gnedt@davizone.at>
> 
> Port of the power save entry retry code from wl1251 driver version included
> in the Maemo Fremantle kernel.
> This tries to enable power save mode up to 3 times before failing.
> 
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
