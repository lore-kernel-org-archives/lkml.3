Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaGVQ5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:57:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53744 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbaGVQ5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:57:43 -0400
Date: Tue, 22 Jul 2014 18:57:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, rric@kernel.org,
        linux-edac@vger.kernel.org, x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v5 2/3] acpi, apei, ghes: Make NMI error notification to
 be GHES architecture extension.
Message-ID: <20140722165739.GG6462@pd.tnic>
References: <1406020813-9176-1-git-send-email-tomasz.nowicki@linaro.org>
 <1406020813-9176-3-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406020813-9176-3-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 11:20:12AM +0200, Tomasz Nowicki wrote:
> Currently APEI depends on x86 architecture. It is because of NMI hardware
> error notification of GHES which is currently supported by x86 only.
> However, many other APEI features can be still used perfectly by other
> architectures.
> 
> This commit adds two symbols:
> 1. HAVE_ACPI_APEI for those archs which support APEI.
> 2. HAVE_ACPI_APEI_NMI which is used for NMI code isolation in ghes.c
>    file. NMI related data and functions are grouped so they can be wrapped
>    inside one #ifdef section. Appropriate function stubs are provided for
>    !NMI case.
> 
> Note there is no functional changes for x86 due to hard selected
> HAVE_ACPI_APEI and HAVE_ACPI_APEI_NMI symbols.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
