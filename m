Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab3BSKEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:04:37 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:34078 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758564Ab3BSKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:04:35 -0500
Date: Tue, 19 Feb 2013 11:04:25 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: remove unecessary __linux__ check
Message-ID: <20130219100425.GB5256@linux-mips.org>
References: <1361261571-1556-1-git-send-email-lig.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361261571-1556-1-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 04:12:51PM +0800, liguang wrote:

> sgidefs.h has strict check for __linux__,
> it seems too harsh, as far as I test, 2 cross
> compiler for mips will not define it automatically,
> and exit build process with error
> "#error Use a Linux compiler or give up".
> remove it will not hurt, I think.

My mailbox used to get flooded by people who attempted to build a kernel
using something like a mips-elf, mips-sde-elf or even stranger targets.
There are further differences than just the definition of __linux__ so
I eventually applied this check.

  Ralf
