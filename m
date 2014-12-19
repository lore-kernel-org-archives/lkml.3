Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaLSB4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:56:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaLSB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:56:34 -0500
Date: Thu, 18 Dec 2014 17:56:33 -0800
From: greg KH <gregkh@linuxfoundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Rastislav Barlik <barlik@zoho.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] samples/kobject: Use kstrtoint instead of sscanf
Message-ID: <20141219015633.GA13956@kroah.com>
References: <1418718668-3646-1-git-send-email-barlik@zoho.com>
 <87388ctq0u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87388ctq0u.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 11:27:37AM +1030, Rusty Russell wrote:
> Rastislav Barlik <barlik@zoho.com> writes:
> > Use kstrtoint function instead of sscanf and check for return values.
> >
> > Signed-off-by: Rastislav Barlik <barlik@zoho.com>
> 
> Hmm, this seems like Greg, not me.
> 
> Greg, I noticed this in samples/kobject/kobject-example.c:
> 
>  * Released under the GPL version 2 only.
> ...
> MODULE_LICENSE("GPL");
> 
> >From module.h:
> 
>  * The following license idents are currently accepted as indicating free
>  * software modules
>  *
>  *	"GPL"				[GNU Public License v2 or later]
>  *	"GPL v2"			[GNU Public License v2]

Thanks, I'll fix that up after 3.19-rc1 is out.

greg k-h
