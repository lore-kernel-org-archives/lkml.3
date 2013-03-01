Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138Ab3CANzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:55:22 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40147 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CANzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:55:20 -0500
Date: Fri, 1 Mar 2013 05:55:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Erik Gilling <konkers@android.com>
Cc: John Stultz <john.stultz@linaro.org>, lkml <linux-kernel@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 10/30] staging: sync: Export sync API symbols
Message-ID: <20130301135529.GB27373@kroah.com>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
 <1362098606-26469-11-git-send-email-john.stultz@linaro.org>
 <20130301020008.GB13367@kroah.com>
 <51302792.6040408@linaro.org>
 <CACSP8Sg=sTbJ_Yv=PdxvHQ--0_rTLN6XG3+0aFKzzHxMzVxKhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACSP8Sg=sTbJ_Yv=PdxvHQ--0_rTLN6XG3+0aFKzzHxMzVxKhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 12:21:24AM -0800, Erik Gilling wrote:
> On Thu, Feb 28, 2013 at 7:59 PM, John Stultz <john.stultz@linaro.org> wrote:
> >> Also, EXPORT_SYMBOL_GPL() perhaps?
> >>
> >> And who is using these exports?
> >
> >
> > From some quick git grepping...
> 
> As John pointed out, the exynos and msm display and code uses them.  I
> know nvidia is working on adding suport to their tegra tree.  My knee
> jerk reaction is to make the export as permissible as possible.  That
> being said, all of the ARM SoC vendors I've worked with have GPL
> kernel drivers even if their user space is closed.  I'll reach out to
> them and ask for their opinions.  Are there any issues with keeping
> them EXPORT_SYMBOL?

There's no "issues", it's just that it is preferred by some people and
companies to add new symbols to the kernel in this manner.  It's really
up to you / Google as you are the ones contributing the code.

thanks,

greg k-h
