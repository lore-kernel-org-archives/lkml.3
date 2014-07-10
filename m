Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaGJBjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 21:39:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGJBjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 21:39:11 -0400
Date: Wed, 9 Jul 2014 18:38:52 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navin.patidar@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/5] staging: rtl8188eu: Remove WEXT_PRIV private ioctl
 handlers
Message-ID: <20140710013852.GA2099@kroah.com>
References: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
 <20140709190419.GA14346@kroah.com>
 <CAPV97yeBsA3A9m=troMHgqUcG2=idCKUWh4sPS+ob0w8VGC76g@mail.gmail.com>
 <20140710005945.GA17129@kroah.com>
 <CAPV97yfNhKFLx0zyppcyX0dQF+iYnhTopavvRGddQQLEGVDQKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPV97yfNhKFLx0zyppcyX0dQF+iYnhTopavvRGddQQLEGVDQKw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 06:56:39AM +0530, navin patidar wrote:
> On Thu, Jul 10, 2014 at 6:29 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Thu, Jul 10, 2014 at 06:24:21AM +0530, navin patidar wrote:
> >> On Thu, Jul 10, 2014 at 12:34 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > On Tue, Jul 01, 2014 at 10:35:09PM +0530, navin patidar wrote:
> >> >> Remove WEXT_PRIV (non-standard) ioctl handlers.
> >> >>
> >> >> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> >> >> ---
> >> >>  drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 6335 +++---------------------
> >> >>  1 file changed, 744 insertions(+), 5591 deletions(-)
> >> >
> >> > This patch fails to apply :(
> >> >
> >> > Can you refresh it, and resend this series?
> >>
> >> Please apply following patches.
> >>
> >> [PATCH v2 1/3] staging: rtl8188eu: re-use mac_pton() helper
> >> [PATCH v2 2/3] staging: rtl8188eu: substitute custom hex2bin()
> >> [PATCH v2 3/3] staging: rtl8188eu: re-use hex_to_bin() instead of custom code
> >>
> >> Then try again to apply my patches.
> >
> > I don't have those, sorry, my patch queue for staging patches are now
> > empty as of everything sent up to yesterday.  Please resend what you
> > want me to apply, in the order in which you want me to apply it.
> 
> Is it okay if i send you a single patch set having my three patch set and
> Andy Shevchenko's patches ?

I don't care :)
