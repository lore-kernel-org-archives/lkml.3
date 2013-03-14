Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab3CNHYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:24:19 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:54516 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3CNHYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:24:18 -0400
Date: Thu, 14 Mar 2013 08:24:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: s390: hypfs: Use PTR_RET function
Message-ID: <20130314072412.GB3480@osiris>
References: <1363201958-17855-1-git-send-email-gheorghiuandru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363201958-17855-1-git-send-email-gheorghiuandru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
x-cbid: 13031407-8372-0000-0000-0000056DDF79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 09:12:38PM +0200, Alexandru Gheorghiu wrote:
> Used PTR_RET function instead of IS_ERR and PTR_ERR.
> Patch found using coccinelle.
> 
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  arch/s390/hypfs/hypfs_dbfs.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 

Applied, thanks.

