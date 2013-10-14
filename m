Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab3JNQk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 12:40:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54963 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757268Ab3JNQkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 12:40:51 -0400
Message-ID: <525C1E1C.9060306@zytor.com>
Date: Mon, 14 Oct 2013 09:38:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH v3 10/10] intel_mid: Moved SFI related code to intel_mid_sfi.c
References: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com> <1381549404-22594-11-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1381549404-22594-11-git-send-email-david.a.cohen@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 08:43 PM, David Cohen wrote:
> From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> 
> Moved SFI specific parsing/handling code to intel_mid_sfi.c. This will enable
> us to reuse our intel-mid code for platforms that supports firmware interfaces
> other than SFI (like ACPI).
> 
> Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  arch/x86/include/asm/intel-mid.h            |   1 +
>  arch/x86/platform/intel-mid/Makefile        |   5 +-
>  arch/x86/platform/intel-mid/intel-mid.c     | 450 --------------------------
>  arch/x86/platform/intel-mid/intel_mid_sfi.c | 485 ++++++++++++++++++++++++++++
>  4 files changed, 489 insertions(+), 452 deletions(-)
>  create mode 100644 arch/x86/platform/intel-mid/intel_mid_sfi.c
> 

Why not just sfi.c?  It is already in a directly named intel-mid.

I presume otherwise this is just code movement... I haven't verified
that, but it looked like it.

	-hpa

