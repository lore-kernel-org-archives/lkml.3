Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3LJJBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:01:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42847 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3LJJBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:01:15 -0500
Date: Tue, 10 Dec 2013 10:01:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Heiko Stuebner <heiko@sntech.de>, ian.campbell@citrix.com,
        rjw@rjwysocki.net, len.brown@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.12 46/62] irq: Enable all irqs unconditionally in
 irq_resume
Message-ID: <20131210090113.GA22756@amd.pavel.ucw.cz>
References: <20131210080057.415644748@linuxfoundation.org>
 <20131210080100.654204750@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210080100.654204750@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 3.12-stable review patch.  If anyone has any objections, please let
>  me know.

Objections... well... I'm not sure if it meets stable criteria. In
particular, I don't think it was ever demonstrated as having bad
effect on the users.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
