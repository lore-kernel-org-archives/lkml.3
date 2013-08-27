Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3H0Jar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:30:47 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:48960 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3H0Jao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:30:44 -0400
Date: Tue, 27 Aug 2013 11:30:41 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, gang.chen@asianux.com
Subject: Re: [PATCH] kernel/padata.c: Register hotcpu notifier after
 initialization
Message-ID: <20130827093041.GD7660@secunet.com>
References: <1377256353-7979-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377256353-7979-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 27 Aug 2013 09:30:42.0124 (UTC) FILETIME=[1961F8C0:01CEA308]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 01:12:33PM +0200, Richard Weinberger wrote:
> padata_cpu_callback() takes pinst->lock, to avoid taking
> an uninitialized lock, register the notifier after it's
> initialization.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looks ok,

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
