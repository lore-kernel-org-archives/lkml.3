Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaGLAey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 20:34:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42680 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaGLAex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 20:34:53 -0400
Date: Fri, 11 Jul 2014 17:39:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, dcb314@hotmail.com
Subject: Re: [PATCH v3] drivers/staging/comedi/drivers/ni_atmio16d.c: remove
 pointless condition
Message-ID: <20140712003921.GA9303@kroah.com>
References: <1405089127-21646-1-git-send-email-abbotti@mev.co.uk>
 <1405089510-23182-1-git-send-email-abbotti@mev.co.uk>
 <53BFF734.2050009@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BFF734.2050009@mev.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:39:48PM +0100, Ian Abbott wrote:
> On 2014-07-11 15:38, Ian Abbott wrote:
> >From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> >
> >From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
> 
> Dammit!  Greg, do you want to sort that out or should I have another go?

Heh, no worries, I can fix it up, thanks.

greg k-h
