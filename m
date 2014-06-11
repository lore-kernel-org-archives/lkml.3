Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbaFKFrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:47:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42429 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaFKFrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:47:47 -0400
Date: Wed, 11 Jun 2014 08:45:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jeff Layton <jlayton@poochiereds.net>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        Jeff Layton <jlayton@primarydata.com>
Subject: Re: [PATCH][RFC] err.h: silence sparse warning: dereference of
 noderef expression
Message-ID: <20140611052040.GM5500@mwanda>
References: <1402436329-24750-1-git-send-email-jlayton@poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402436329-24750-1-git-send-email-jlayton@poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 05:38:49PM -0400, Jeff Layton wrote:
> From: Jeff Layton <jlayton@primarydata.com>
> 
> Lately, when I do a make with C=1, I get *tons* of these warnings:
> 
>     include/linux/err.h:35:16: warning: dereference of noderef expression
>     include/linux/err.h:30:23: warning: dereference of noderef expression

Which version of Sparse, which version of the kernel and which .c file
can I compile to reproduce this?

I built fs/cifs/ and I didn't see the sparse warning.

regards,
dan carpenter

