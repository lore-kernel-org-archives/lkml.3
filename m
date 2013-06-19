Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab3FSJNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:13:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934588Ab3FSJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:13:43 -0400
Date: Wed, 19 Jun 2013 02:13:42 -0700 (PDT)
Message-Id: <20130619.021342.853193458609177361.davem@davemloft.net>
To: gang.chen@asianux.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, sam@ravnborg.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] arch: sparc: prom: looping issue, need additional
 length check in the outside looping
From: David Miller <davem@davemloft.net>
In-Reply-To: <51A6C8FA.3080408@asianux.com>
References: <51A6C8FA.3080408@asianux.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen@asianux.com>
Date: Thu, 30 May 2013 11:35:22 +0800

> 
> When "cp >= barg_buf + BARG_LEN-2", it breaks internel looping 'while',
> but outside loop 'for' still has effect, so "*cp++ = ' '" will continue
> repeating which may cause memory overflow.
> 
> So need additional length check for it in the outside looping.
> 
> Also beautify the related code which found by "./scripts/checkpatch.pl"

Applied.
