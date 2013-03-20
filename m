Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934434Ab3CTBFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:05:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42284 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3CTBFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:05:52 -0400
Message-ID: <51490B5F.7070909@zytor.com>
Date: Tue, 19 Mar 2013 18:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, kexec@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <51490ABD.3050205@zytor.com>
In-Reply-To: <51490ABD.3050205@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 06:02 PM, H. Peter Anvin wrote:
> 
> Looking at it in detail, EVERYTHING in CAP_SYS_RAWIO has the possibility
> of compromising the kernel, because they let device drivers be bypassed,
> which means arbitrary DMA, which means you have everything.
> 

Well, *unless* you have an iommu that you *actually know* is protecting you.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

