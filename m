Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab3KZXdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:33:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37278 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab3KZXdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:33:54 -0500
Message-ID: <52952FD9.1060906@zytor.com>
Date: Tue, 26 Nov 2013 15:33:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Roland Kletzing <devzero@web.de>, kernel-team@lists.ubuntu.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] - add "fixpae" bootparam to fix/workaround #930447
References: <trinity-1045dd8c-e43f-4f8c-94e4-c0f0f15f611d-1385507362267@3capp-webde-bs36>
In-Reply-To: <trinity-1045dd8c-e43f-4f8c-94e4-c0f0f15f611d-1385507362267@3capp-webde-bs36>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 03:09 PM, Roland Kletzing wrote:
> Hello kernel-team, 
> 
> regarding https://bugs.launchpad.net/ubuntu/+source/syslinux/+bug/930447 , i have developed a simple patch to (hopefully) provide an easy and elegant workaround/fix for the issue. I assume some hundred users (if not some thousand, as entries in bugreports are only the tip of an iceberg) are affected by this issue.
> 
> Please take a review and feel free to merge.
> 
> As defaulting to PAE kernels is specific for some distros only, i think this is no patch for mainline (yet).
> 
> I did not often do patches, nor am i a good programmer - so sorry if the patch or the submission style is not perfect.
> 
> regards
> Roland

No, this is not an acceptable patch per se.

The right way to do this is to have the option, if it is found, simply
set the bit in the CPU array.  However, it is important to verify that
we are on the affected type of CPU, specifically the affected Pentium Ms.

x86 patches should be sent to <x86@kernel.org> or equivalently myself,
<mingo@kernel.org> and <tglx@linutronix.de> and Cc:
<linux-kernel@vger.kernel.org>.  I also encourage you to read the file
Documentation/SubmittingPatches before trying again.

	-hpa

