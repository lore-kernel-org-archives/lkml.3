Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3EHLGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:06:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46796 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EHLGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:06:17 -0400
Date: Wed, 8 May 2013 13:06:11 +0200
From: Robert Richter <rric@kernel.org>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, SH-Run Zhen RZ Wang <rzwang@cn.ibm.com>
Subject: Re: [PATCH] perf tools: Fix perf version generation
Message-ID: <20130508110611.GA8356@rric.localhost>
References: <1368006214-12912-1-git-send-email-rric@kernel.org>
 <518A2B4B.4040509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A2B4B.4040509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.05.13 18:39:07, Xiao Guangrong wrote:
> I remember that Wang has posted a similar patch to fix this bug several
> weeks ago:
> 	http://lkml.org/lkml/2013/4/24/70
> 
> But have no response yet.

Yes, this patch would fix the version tag too.

The patch I wrote also reports a commit id even in the case when no
tag is found. This was the original reason why I stumbled over this.
Assume a repository for testing there you just push the commit id to.
This does not contain any tags but a valid commit id. Now, it
determines the version tag from the makefile but does not drop the
commit id.

-Robert
