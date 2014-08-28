Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaH1Poq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaH1Pop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:44:45 -0400
Date: Thu, 28 Aug 2014 08:44:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Janet Liu <jianhua.ljh@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [PATCH] staging:lustre:lnet: lib-md.c fix checkpath
 warnings and errors.
Message-ID: <20140828154403.GA19152@kroah.com>
References: <20140827012245.GA26157@kroah.com>
 <53FE91E1.1020006@qq.com>
 <53FE9289.3050809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FE9289.3050809@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:23:05AM +0800, Janet Liu wrote:
> On 08/28/2014 10:20 AM, Janet Liu wrote:
> >
> >
> >
> >-------- Original Message --------
> >Subject: Re: [PATCH] staging:lustre:lnet: lib-md.c fix checkpath
> >warnings and errors.
> >Date: Tue, 26 Aug 2014 18:22:45 -0700
> >From: Greg KH <gregkh@linuxfoundation.org>
> >To: Janet Liu <janetliu526@qq.com>
> >CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
> >
> >On Mon, Aug 25, 2014 at 01:18:54AM +0800, Janet Liu wrote:
> >>Sliences the following warning and error:
> >>
> >>  WARNING: line over 80 characters
> >>  WARNING: space prohibited between function name and open parenthesis
> >>'('
> >>  ERROR: do not use C99 // comments
> >>  ERROR: trailing statements should be on next line
> >
> >You changed 4 things, in one patch :(
> >
> >Also, you sent 4 different patches, which one is correct?
> >
> >Please only do one thing per patch and please resend with the one that
> >you wish to have reviewed.
> >
> >thanks,
> >
> >greg k-h
> >
> >
> Hi Greg,
> 
> I'm very sorry for having troubled you.
> 
> The latest one is correct. It is send by my gmail box.

I don't know what is the "latest one", if you do not version your
patches with a "v2" or "v3" and the like in the subject area.  Otherwise
we are relying on mail timestamps, which are not always correct.

thanks,

greg k-h
