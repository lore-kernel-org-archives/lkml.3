Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbaICNSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:18:24 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37159 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbaICNSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:18:21 -0400
Date: Wed, 3 Sep 2014 14:18:18 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laszlo Ersek <lersek@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v2 0/5] beautify EFI memmap logs
Message-ID: <20140903131818.GE3001@console-pimps.org>
References: <1409743943-16934-1-git-send-email-lersek@redhat.com>
 <CAKv+Gu_Yk-q0gf+EHc3EYQ=obLT2nj6Kj6qPTk678ASFEW+ZFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_Yk-q0gf+EHc3EYQ=obLT2nj6Kj6qPTk678ASFEW+ZFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep, at 03:01:31PM, Ard Biesheuvel wrote:
> 
> Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> (on arm64 only)
> 
> +1 for aligning between architectures
> +1 for cleaning up the output to make it more readable
 
Thanks Ard.

> The only thing I am not entirely convinced about is printing all those
> memory attributes: is it really so interesting to know that region X
> /can/ be configured as writeback, write through, write combining etc
> etc, as most regions seem to support most attributes, yet it tells you
> nothing about what the kernel ends up doing with that information. In
> the arm64 case, for instance, all MEMORY_WB ranges are mapped
> writeback cached, and everything else is mapped uncached.

Personally, I think it's good to get an unadulterated version of the
firmware memory map (for vicarious debugging) before the kernel has a
chance to mess with it.

-- 
Matt Fleming, Intel Open Source Technology Center
