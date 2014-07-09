Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaGIEzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 00:55:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaGIEzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 00:55:54 -0400
Date: Tue, 8 Jul 2014 21:55:53 -0700
From: gregkh <gregkh@linuxfoundation.org>
To: Anton Protopopov <a.s.protopopov@gmail.com>
Cc: devel@driverdev.osuosl.org, abbotti <abbotti@mev.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: check the return value of
 kobject_set_name
Message-ID: <20140709045553.GA9861@kroah.com>
References: <1402149415-20037-1-git-send-email-a.s.protopopov@gmail.com>
 <5395860E.3070000@mev.co.uk>
 <CAGn_itzc_Lnu6qNTin6eDcBirJE3mHEp2_Ex+H6tqLA2OUBBjw@mail.gmail.com>
 <20140709042845.GA8664@kroah.com>
 <53BCC9B5.8080201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53BCC9B5.8080201@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 08:48:53AM +0400, Anton Protopopov wrote:
> 
> 
> 09.07.2014 08:28, gregkh пишет:
> > On Wed, Jul 09, 2014 at 08:24:06AM +0400, Anton Protopopov wrote:
> >> 2014-06-09 14:01 GMT+04:00 Ian Abbott <abbotti@mev.co.uk>:
> >>> On 2014-06-07 14:56, Anton Protopopov wrote:
> >>>>
> >>>> Added a check of the return value of the kobject_set_name function.
> >>>>
> >>>> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> >>>> ---
> >>>>   drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
> >>>>   1 file changed, 8 insertions(+), 1 deletion(-)
> >>>
> >>>
> >>> Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
> >>
> >> This patch was lost, I guess?
> > 
> > I don't seem to have it anymore in my inbox, please resend.
> > 
> > greg k-h
> > 
> 
> 
> Added a check of the return value of the kobject_set_name function.
> 
> Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
> ---
>  drivers/staging/comedi/comedi_fops.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Please send in a format I can apply in (i.e. I don't have to edit the
changelog by hand...)
