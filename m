Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab3BXOje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 09:39:34 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64239 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757908Ab3BXOjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 09:39:33 -0500
Date: Sun, 24 Feb 2013 06:40:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dongsheng Song <dongsheng.song@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130224144017.GB1111@kroah.com>
References: <20130223072959.GA4894@www.outflux.net>
 <CAE8XmWoX_TyHMTnGCMn6j_qiK0hptCgyrnVYpDJkfTAQfUNQPA@mail.gmail.com>
 <CAGXu5jKkaTStWRDQLOb6HxM7sGyj+1ekxxkGK8hw6rWkHRrVsQ@mail.gmail.com>
 <CAE8XmWq+dA5Pvhyoxm2Nqbt0psLpPxUdR7i5MKFhxVxubY0QtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE8XmWq+dA5Pvhyoxm2Nqbt0psLpPxUdR7i5MKFhxVxubY0QtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 05:51:44PM +0800, Dongsheng Song wrote:
> On Sun, Feb 24, 2013 at 1:03 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Sat, Feb 23, 2013 at 3:59 AM, Dongsheng Song
> > <dongsheng.song@gmail.com> wrote:
> >> On Sat, Feb 23, 2013 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> >>>
> >>> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> >>> while now and is almost always enabled by default. As agreed during the
> >>> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> >>>
> >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> >>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >>> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> >>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>> ---
> >>>  arch/x86/xen/Kconfig |    2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> >>> index 93ff4e1..8cada4c 100644
> >>> --- a/arch/x86/xen/Kconfig
> >>> +++ b/arch/x86/xen/Kconfig
> >>> @@ -53,7 +53,7 @@ config XEN_DEBUG_FS
> >>>
> >>>  config XEN_X86_PVH
> >>>         bool "Support for running as a PVH guest (EXPERIMENTAL)"
> >>
> >> Why not remove this 'EXPERIMENTAL' too ?
> >
> > It was unclear to me if the feature was actually considered unstable.
> > I can resend with the text removed from the title too, if that's the
> > correct action here?
> >
> > -Kees
> >
> 
> If such a feature was considered unstable, it should depends on EXPERIMENTAL.

CONFIG_EXPERIMENTAL is going away.

> We should not surprised users.

You should not have unstable options in the kernel in the first place,
sorry.

greg k-h
