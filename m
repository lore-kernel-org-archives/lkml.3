Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaIBRj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:39:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbaIBRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:39:27 -0400
Date: Tue, 2 Sep 2014 10:39:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Chase Southwood <chase.southwood@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: comedi: usbduxsigma: fix more sparse endianness
 warnings
Message-ID: <20140902173927.GA6783@kroah.com>
References: <1409514300-15493-1-git-send-email-chase.southwood@gmail.com>
 <54043B09.4000602@mev.co.uk>
 <54043B58.6030108@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54043B58.6030108@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 10:24:40AM +0100, Ian Abbott wrote:
> On 2014-09-01 10:23, Ian Abbott wrote:
> >On 2014-08-31 20:45, Chase Southwood wrote:
> >>Sparse shows a couple of warnings like:
> >>
> >>drivers/staging/comedi/drivers/usbduxsigma.c:787:23: warning: cast to
> >>restricted __be32
> >>
> >>Looking at the indicated lines shows that the issue is caused by an
> >>incorrect cast to uint32_t instead of __be32.  Fix this cast.
> >>
> >>Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
> >>Cc: Ian Abbott <abbotti@mev.co.uk>
> >>Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> >>---
> >>  drivers/staging/comedi/drivers/usbduxsigma.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> >Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
> 
> I meant:
> 
> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

Either is fine, especially as you are listed as the maintainer of this
subsystem :)
