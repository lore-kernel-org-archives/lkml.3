Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3CLNyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:54:46 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:34966 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLNyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:54:45 -0400
Date: Tue, 12 Mar 2013 14:54:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Zhi-zhou Zhang <zhizhou.zh@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: lib/bitops.c: fix wrong return type
Message-ID: <20130312135441.GA13792@linux-mips.org>
References: <n>
 <1363093253-17595-1-git-send-email-zhizhou.zh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363093253-17595-1-git-send-email-zhizhou.zh@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 09:00:53PM +0800, Zhi-zhou Zhang wrote:

> Here should return 64-bit types rather than 32-bit types. Or we
> may get wrong return value if high 32-bit isn't equal to zero.

David Daney's patch which I've applied not two hours before you posted
this patch solves the same issue though a different way.  So I'm just
going to drop this patch.

Thanks anyway!

  Ralf
