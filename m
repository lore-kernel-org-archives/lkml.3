Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaGBMQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:16:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaGBMQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:16:48 -0400
Date: Wed, 2 Jul 2014 14:16:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com,
        m.chehab@samsung.com, bp@suse.de, linux-edac@vger.kernel.org,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        rric@kernel.org
Subject: Re: [PATCH v4 1/3] apei, mce: Factor out APEI architecture specific
 MCE calls.
Message-ID: <20140702121640.GE1318@pd.tnic>
References: <1403610095-5354-1-git-send-email-tomasz.nowicki@linaro.org>
 <1403610095-5354-2-git-send-email-tomasz.nowicki@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1403610095-5354-2-git-send-email-tomasz.nowicki@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:41:33PM +0200, Tomasz Nowicki wrote:
> This commit abstracts MCE calls and provides weak corresponding default
> implementation for those architectures which do not need arch specific
> actions. Each platform willing to do additional architectural actions
> should provides desired function definition. It allows us to avoid wrap
> code into #ifdef in generic code and prevent new platform from introducing
> dummy stub function too.
> 
> Initially, there are two APEI arch-specific calls:
> - arch_apei_enable_cmcff()
> - arch_apei_report_mem_error()
> Both interact with MCE driver for X86 architecture.
> 
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
