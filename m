Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab3KMM3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:29:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45619 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758511Ab3KMM3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:29:12 -0500
Date: Wed, 13 Nov 2013 12:29:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] aio: checking for NULL instead of IS_ERR
Message-ID: <20131113122907.GA13318@ZenIV.linux.org.uk>
References: <20131113074940.GG25541@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113074940.GG25541@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:49:40AM +0300, Dan Carpenter wrote:
> alloc_anon_inode() returns an ERR_PTR(), it doesn't return NULL.
> 
> Fixes: 71ad7490c1f3 ('rework aio migrate pages to use aio fs')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
