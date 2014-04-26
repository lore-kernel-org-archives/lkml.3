Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaDZPmJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:42:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDZPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:42:07 -0400
Date: Sat, 26 Apr 2014 08:42:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sami Laine <laine.j.sami@gmail.com>
Cc: daeseok.youn@gmail.com, devel@driverdev.osuosl.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next-20140424] staging/cxt1e1: hwprobe.c sparse warning
 corrections
Message-ID: <20140426154247.GA18512@kroah.com>
References: <20140426153033.GA4088@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140426153033.GA4088@acer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 06:30:33PM +0300, Sami Laine wrote:
> From: Sami Laine <laine.j.sami@gmail.com>
> 
> Sparse warning corrections:
>  - declarations made static where they should be such
>  - changed NULL-pointers as NULL instead of static 0's
>  - added __force to a few casts seemingly safe enough

You did 3 different things here, can you split this up into 3 different
patches?  Especially as someone already sent in the NULL pointer
patch...

thanks,

greg k-h
