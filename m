Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760413AbaJ3O6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:58:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:35799 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887AbaJ3O6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:58:49 -0400
Date: Thu, 30 Oct 2014 15:58:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: "pang.xunlei" <pang.xunlei@linaro.org>, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        John Stultz <john.stultz@linaro.org>, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [RFC PATCH v2 08/11] time: Convert xen_read_wallclock()
 to use timespec64
In-Reply-To: <54522159.8070204@citrix.com>
Message-ID: <alpine.DEB.2.11.1410301557350.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-9-git-send-email-pang.xunlei@linaro.org> <54522159.8070204@citrix.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, David Vrabel wrote:

> On 30/10/14 11:15, pang.xunlei wrote:
> > As part of addressing 2038 safety for in-kernel uses, this patch
> > creates no functional change, converts xen_read_wallclock() to
> > use timespec64 instead of timespec.
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> 
> But I do think all the TODOs for things that are fixed by later patches
> in the series aren't necessary.

Amen to that.

And of course the whole XEN part should be a seperate series on top of
the series which provides the new core interfaces.

Thanks,

	tglx
