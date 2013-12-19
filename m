Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3LSP7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:59:01 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51759 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3LSP65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:58:57 -0500
Date: Fri, 20 Dec 2013 00:58:51 +0900
From: Ryo Munakata <ryomnktml@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-Id: <20131220005851.14c72baecfcf67d33877d996@gmail.com>
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 13:10:37 -0800
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 3.12.6 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc1.gz
> and the diffstat can be found below.


Results:
	Target:		3.12.6-rc2
	Patching:	No errors
	Compilation:	No errors
	Boot:		No errors
	dmesg:		No regressions compared to the previous stable kernel

	Looks good to me.


Test and build environment:
	Dell System XPS L502X/0NJT03, BIOS A12 09/07/2012
	CPU:		Intel(R) Core(TM) i7-2630QM CPU @ 2.00GHz
	RAM:		4 GB
	OS:		Arch Linux
	Arch:		i686
	Compiler:	gcc (GCC) 4.8.2

Thanks.

-- 
Ryo Munakata <ryomnktml@gmail.com>
