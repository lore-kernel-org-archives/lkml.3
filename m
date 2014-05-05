Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbaEEPdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:33:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60020 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbaEEPdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:33:50 -0400
Date: Mon, 5 May 2014 17:33:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 1/7] apei, mce: Call MCE-specific code only for X86
 architecture.
Message-ID: <20140505153348.GD4373@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-2-git-send-email-tomasz.nowicki@linaro.org>
 <20140505114445.GB4373@pd.tnic>
 <5367A181.3060300@linaro.org>
 <20140505145331.GC4373@pd.tnic>
 <5367AEF7.40804@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5367AEF7.40804@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 05:32:07PM +0200, Tomasz Nowicki wrote:
> You are right! I will fix that big misunderstanding from my side in
> next patch version.

Ok, but pls wait with resubmitting until I take a look at the rest of
your patches.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
