Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3LJJHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:07:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59438 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3LJJHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:07:10 -0500
Date: Tue, 10 Dec 2013 01:08:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Heiko Stuebner <heiko@sntech.de>, ian.campbell@citrix.com,
        rjw@rjwysocki.net, len.brown@intel.com,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.12 46/62] irq: Enable all irqs unconditionally in
 irq_resume
Message-ID: <20131210090847.GA4600@kroah.com>
References: <20131210080057.415644748@linuxfoundation.org>
 <20131210080100.654204750@linuxfoundation.org>
 <20131210090113.GA22756@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210090113.GA22756@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 10:01:13AM +0100, Pavel Machek wrote:
> Hi!
> 
> > 3.12-stable review patch.  If anyone has any objections, please let
> >  me know.
> 
> Objections... well... I'm not sure if it meets stable criteria. In
> particular, I don't think it was ever demonstrated as having bad
> effect on the users.

Well, I'm guessing someone on the cc: here wanted it in stable@, so I'll
let them speak up as to why...
