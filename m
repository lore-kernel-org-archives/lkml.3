Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbbALQ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:26:17 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:45975 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbbALQ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:26:15 -0500
Date: Mon, 12 Jan 2015 16:26:12 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Roy Franz <roy.franz@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Mark Salter <msalter@redhat.com>,
        Geoff Levand <geoff.levand@linaro.org>, Dave Young <dyoung@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Message-ID: <20150112162612.GH26589@codeblueprint.co.uk>
References: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
 <1420742914-2404-7-git-send-email-ard.biesheuvel@linaro.org>
 <20150112114600.GE26589@codeblueprint.co.uk>
 <CAKv+Gu9BQFEEpEpF3-O98W-kBYQC9yKf39ee2gvznuZYPiCo-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9BQFEEpEpF3-O98W-kBYQC9yKf39ee2gvznuZYPiCo-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan, at 04:09:24PM, Ard Biesheuvel wrote:
> 
> Cheers Matt
> 
> It appears this series is converging in time for 3.20, but this patch
> still lacks acked/reviewed-bys
> 
> Are you ok with the remainder of the patch as well? In that case, may
> I have your ack so the series can be merged through the arm64 tree?

You got it.

Acked-by: Matt Fleming <matt.fleming@intel.com>

-- 
Matt Fleming, Intel Open Source Technology Center
