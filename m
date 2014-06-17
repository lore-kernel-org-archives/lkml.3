Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081AbaFQOYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:24:06 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:53891 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaFQOYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:24:03 -0400
Date: Tue, 17 Jun 2014 10:23:59 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH -next 03/26] ata: Use dma_zalloc_coherent
Message-ID: <20140617142359.GA31819@htj.dyndns.org>
References: <cover.1402863904.git.joe@perches.com>
 <2be5da39b914e5f9d845c0f789267e80c188d5b5.1402863905.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2be5da39b914e5f9d845c0f789267e80c188d5b5.1402863905.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 01:37:32PM -0700, Joe Perches wrote:
> Use the zeroing function instead of dma_alloc_coherent & memset(,0,)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to cgroup/for-3.17.

Thanks.

-- 
tejun
