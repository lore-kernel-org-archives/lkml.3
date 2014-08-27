Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaH0BWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:22:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaH0BWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:22:46 -0400
Date: Tue, 26 Aug 2014 18:22:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Janet Liu <janetliu526@qq.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:lustre:lnet: lib-md.c fix checkpath warnings and
 errors.
Message-ID: <20140827012245.GA26157@kroah.com>
References: <1408900734-8256-1-git-send-email-janetliu526@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408900734-8256-1-git-send-email-janetliu526@qq.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 01:18:54AM +0800, Janet Liu wrote:
> Sliences the following warning and error:
> 
>   WARNING: line over 80 characters
>   WARNING: space prohibited between function name and open parenthesis '('
>   ERROR: do not use C99 // comments
>   ERROR: trailing statements should be on next line

You changed 4 things, in one patch :(

Also, you sent 4 different patches, which one is correct?

Please only do one thing per patch and please resend with the one that
you wish to have reviewed.

thanks,

greg k-h
