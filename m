Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaFLVQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:16:14 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47591 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaFLVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:16:13 -0400
Subject: Re: [PATCH 1/1] Remove an extra operation: The ESR has been stored into x1, and should be directly pass to do_sp_pc_abort function
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <1402587132-4853-1-git-send-email-andy.jhshiu@gmail.com>
Date: Thu, 12 Jun 2014 22:16:09 +0100
Cc: Will Deacon <Will.Deacon@arm.com>, Mark Brown <broonie@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Transfer-Encoding: 7bit
Message-Id: <BC9ADAC0-BD35-4A54-AEF2-CF4F9520D04A@arm.com>
References: <1402587132-4853-1-git-send-email-andy.jhshiu@gmail.com>
To: Andy Hsu <andy.jhshiu@gmail.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Jun 2014, at 16:32, Andy Hsu <andy.jhshiu@gmail.com> wrote:
> Signed-off-by: Andy Hsu <andy.jhshiu@gmail.com>
> ---
> arch/arm64/kernel/entry.S |    1 -
> 1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index fa78916..56ef569 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -275,7 +275,6 @@ el1_sp_pc:
> 	 * Stack or PC alignment exception handling
> 	 */
> 	mrs	x0, far_el1
> -	mov	x1, x25
> 	mov	x2, sp
> 	b	do_sp_pc_abort
> el1_undef:

I got it already via a different channel but thanks anyway.

Catalin
