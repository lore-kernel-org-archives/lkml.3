Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3A1VWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:22:12 -0500
Received: from void.printf.net ([89.145.121.20]:35131 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab3A1VWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:22:09 -0500
From: Chris Ball <cjb@laptop.org>
To: "Maya Erez" <merez@codeaurora.org>
Cc: "'Subhash Jadavani'" <subhashj@codeaurora.org>,
        <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: core: disable the cache before suspend only after stopping BKOPS
References: <1357936936-25977-1-git-send-email-merez@codeaurora.org>
	<50F10B86.6020905@codeaurora.org>
	<002701cdf1d7$99dd1d00$cd975700$@codeaurora.org>
Date: Mon, 28 Jan 2013 16:21:27 -0500
In-Reply-To: <002701cdf1d7$99dd1d00$cd975700$@codeaurora.org> (Maya Erez's
	message of "Sun, 13 Jan 2013 23:47:21 +0200")
Message-ID: <87fw1l80mg.fsf@laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maya,

On Sun, Jan 13 2013, Maya Erez wrote:
> Agreed, I will change the commit text in the next uploaded version.

I haven't seen the updated patch go by -- please could you send it when
you get a chance?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
