Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaHPRuO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 13:50:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaHPRuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 13:50:12 -0400
Date: Sat, 16 Aug 2014 10:49:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mohan Rajanna <mohan.ostfold@gmail.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org
Subject: Re: UEFI booting Kernel without bootloader
Message-ID: <20140816174937.GA17134@kroah.com>
References: <CAFxKfpxre4KvgsbeWs5HSehf8VLDSLDAUfjGLQsicxuankCbtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFxKfpxre4KvgsbeWs5HSehf8VLDSLDAUfjGLQsicxuankCbtQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2014 at 05:24:08PM +0530, Mohan Rajanna wrote:
> Dear Elites,
> 
>  
> 
> Since I am not supposed to ask questions directly to Greg, So posting my query
> to you all.

You shouldn't ever ask questions only to a kernel developer, that's what
a mailing list is for.

> Query:
> 
>                 I am doing study on necessary changes required to boot Kernel
> and initrd directly from UEFI without boot loader support. I found very helping
> stuff in below link.
> 
> http://www.kroah.com/log/
> 
> Can I get concrete configuration steps for the same.

What did you try that did not work?

>                 What are the impact/dependencies if boot loader is not used ?

Upgrading a kernel version is totally different, you need to tell UEFI
about it, which is different from what distros currently do.

thanks,

greg k-h
