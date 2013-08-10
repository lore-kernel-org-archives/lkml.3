Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246Ab3HJO5H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 10:57:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59422 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934034Ab3HJO5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 10:57:05 -0400
Date: Sat, 10 Aug 2013 16:57:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] mce: acpi/apei: Only disable banks listed in HEST if mce
 is configured
Message-ID: <20130810145701.GA10885@pd.tnic>
References: <0129220@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0129220@agluck-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 09:50:15AM -0700, Luck, Tony wrote:
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> 
> Randconfig testing found this error:
> >> hest.c(.init.text+0x6004): undefined reference to 'mce_disable_bank'
> 
> Fix by wrapping body of hest_parse_cmc() inside #ifdef CONFIG_X86_MCE
> 
> Reported-by: "Wu, Fengguang" <fengguang.wu@intel.com>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

> ---
> 
> [Peter: Thanks for pulling Naveen's series from my ras tree. Fengguang's
>  testbuild robot promtly found this build issue. Please apply this patch
>  on top of the x86/mce branch. - Thanks]

This one still needs picking up since randconfig builds fail. hpa, can
you apply to tip:x86/mce please?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
