Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaFXXYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:24:53 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34768 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaFXXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:24:52 -0400
Date: Wed, 25 Jun 2014 00:24:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: T Makphaibulchoke <tmac@hp.com>
cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH] fs/mbcache.c: replacing __builtin_log2() with ilog2()
In-Reply-To: <1401471304-37479-1-git-send-email-tmac@hp.com>
Message-ID: <alpine.LFD.2.11.1406250017571.23403@eddie.linux-mips.org>
References: <1401471304-37479-1-git-send-email-tmac@hp.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014, T Makphaibulchoke wrote:

> Fixing compiler error with some gcc version(s) that do not
> support __builtin_log2().  Replacing __builtin_log2() with
> ilog2().
> 
> Signed-off-by: T. Makphaibulchoke <tmac@hp.com>

Reviewed-by: Maciej W. Rozycki <macro@linux-mips.org>

  Maciej
