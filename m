Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3KEEbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 23:31:25 -0500
Received: from intranet.asianux.com ([58.214.24.6]:26760 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KEEbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 23:31:24 -0500
X-Spam-Score: -106.8
Message-ID: <5278745A.9000400@asianux.com>
Date: Tue, 05 Nov 2013 12:30:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gang.chen@asianux.com, tglx@linutronix.de
CC: tip-bot for Chen Gang <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86, defconfig: Add DEVTMPFS and DEVTMPFS_MOUNT
 to *86*_defconfig
References: <52784DFF.8040004@asianux.com> <tip-7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4@git.kernel.org>
In-Reply-To: <tip-7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2013 12:03 PM, tip-bot for Chen Gang wrote:
> Commit-ID:  7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4
> Gitweb:     http://git.kernel.org/tip/7f71be4c9f9a334e7bd0adc66225db4eb88c3bc4
> Author:     Chen Gang <gang.chen@asianux.com>
> AuthorDate: Tue, 5 Nov 2013 09:46:39 +0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 4 Nov 2013 20:01:55 -0800
> 
> x86, defconfig: Add DEVTMPFS and DEVTMPFS_MOUNT to *86*_defconfig
> 
> The defconfig kernel can not run under neither fedora16 x86_64 laptop
> nor fedora17 x86_64 pc. After enable DEVTMPFS* in x86_64_defconfig, it
> will be OK.
> 
> DEVTMPFS* is only related with software, so for i386_defconfig may also
> need them (at least, it has no negative effect for defconfig).
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Link: http://lkml.kernel.org/r/52784DFF.8040004@asianux.com
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>


Thanks.
-- 
Chen Gang
