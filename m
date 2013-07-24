Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3GXW0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:26:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3GXW0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:26:41 -0400
Date: Wed, 24 Jul 2013 15:26:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH 22/36] staging: comedi: convert class code to use
 dev_groups
Message-ID: <20130724222640.GA22336@kroah.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
 <1374703539-9705-23-git-send-email-gregkh@linuxfoundation.org>
 <ADE657CA350FB648AAC2C43247A983F0021DAC5C1F40@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DAC5C1F40@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 05:11:25PM -0500, H Hartley Sweeten wrote:
> On Wednesday, July 24, 2013 3:05 PM, Greg Kroah-Hartman wrote:
> >
> > The dev_attrs field of struct class is going away soon, dev_groups
> > should be used instead.  This converts the comedi class code to use the
> > correct field.
> >
> > Cc: Ian Abbott <abbotti@mev.co.uk>
> > Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/staging/comedi/comedi_fops.c | 39 ++++++++++++++++++------------------
> >  1 file changed, 20 insertions(+), 19 deletions(-)
> 
> Looks good to me. Not sure what my sign off should be so take your pick.
> 
> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks, I'll take both :)

greg k-h
