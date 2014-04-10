Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbaDJUNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:13:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:37382 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759128AbaDJUNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:13:34 -0400
X-Sasl-enc: K7a4+Ov7vsT7lIx3HRfXeuaLFX8dIZeXL53h9Owwp9Mn 1397160813
Date: Thu, 10 Apr 2014 13:16:06 -0700
From: Greg KH <greg@kroah.com>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [WIP] [PATCH v2 0/3] remove wrong cast of gfp_t flags
Message-ID: <20140410201606.GA12335@kroah.com>
References: <20140403094350.GH6991@mwanda>
 <cover.1396627781.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1396627781.git.silvio.fricke@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 12:32:07AM +0200, Silvio Fricke wrote:
> Hi Dan,
> 
> thanks for your review.
> Attached second version of this series.

I don't understand what the [WIP] marking is.  Please just resend these
as "real" patches if you feel they are ready to be merged.  If we have
issues with them, we will be sure to let you know :)

thanks,

greg k-h
