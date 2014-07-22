Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaGVEhl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:37:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41285 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaGVEhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:37:40 -0400
Date: Mon, 21 Jul 2014 21:37:38 -0700 (PDT)
Message-Id: <20140721.213738.1831544429590257732.davem@davemloft.net>
To: khalid.aziz@oracle.com
Cc: sam@ravnborg.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] sparc: Add support for seek and shorter read to
 /dev/mdesc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405696541-25189-1-git-send-email-khalid.aziz@oracle.com>
References: <1405696541-25189-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 21:37:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Khalid Aziz <khalid.aziz@oracle.com>
Date: Fri, 18 Jul 2014 09:15:40 -0600

> /dev/mdesc on Linux does not support reading arbitrary number
> of bytes and seeking while /dev/mdesc on Solaris does. This
> causes tools that work on Solaris to break on Linux. This patch
> adds these two capabilities to /dev/mdesc.
> 
> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>

Applied to sparc-next, thanks.
