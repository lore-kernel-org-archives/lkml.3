Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3KUPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:16:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KUPQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:16:27 -0500
Date: Thu, 21 Nov 2013 07:16:56 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH -v2 09/10] mfd: staging: Constify struct mfd_cell where
 possible
Message-ID: <20131121151656.GA1988@kroah.com>
References: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
 <1384781586-4798-9-git-send-email-geert@linux-m68k.org>
 <20131121110211.GB23067@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121110211.GB23067@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:02:11AM +0000, Lee Jones wrote:
> On Mon, 18 Nov 2013, Geert Uytterhoeven wrote:
> 
> > As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
> > refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
> > mfd_add_devices() is "const" again. Hence make all cell data passed to
> > mfd_add_devices() const where possible.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: devel@driverdev.osuosl.org
> > ---
> > v2: Split in groups
> > 
> >  drivers/staging/nvec/nvec.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> It looks like I need Greg's Ack on this before I apply it.

No need, I've already queued it up for 3.14-rc1.

thanks,

greg k-h
