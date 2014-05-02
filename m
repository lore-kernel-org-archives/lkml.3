Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaEBSWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 14:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaEBSWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 14:22:09 -0400
Date: Fri, 2 May 2014 20:22:00 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] mm/zswap.c: add lock helper
Message-ID: <20140502182158.GC13207@mguzik.redhat.com>
References: <20140502183510.21ee4a06d787b3882e77faba@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140502183510.21ee4a06d787b3882e77faba@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 06:35:10PM +0200, Fabian Frederick wrote:
> &tree->lock is used all over the place
> 
[..]
> +	spinlock_t *lock = &tree->lock;
>  
>  	if (!tree)
>  		return;
>  

Rather fishy, although I'm unsure if this is a real problem.

-- 
Mateusz Guzik
