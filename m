Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaEOWEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:04:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbaEOWEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:04:49 -0400
Date: Thu, 15 May 2014 15:08:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Masood Mehmood <ody.guru@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
Message-ID: <20140515220808.GA13306@kroah.com>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 11:53:53PM +0200, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/tidspbridge/rmgr/node.c |    4 ++--
>  1 fil ändrad, 2 tillägg(+), 2 borttagningar(-)

Please work a bit on your Subject lines to make it easier to figure out
where the patches belong.

For this one, it should be:
	Subject: staging: tidspridge: fix for possible null pointer dereference in node.c
or:
	Subject: staging: tidspridge: node.c: fix for possible null pointer dereference

That way people can figure out _what_ node.c file you are referring to
and to see if they care about it or not :)

thanks,

greg k-h
