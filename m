Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaA2RRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 12:17:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45310 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaA2RRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 12:17:40 -0500
Message-ID: <52E93768.5000103@zytor.com>
Date: Wed, 29 Jan 2014 09:16:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
CC: catalin.marinas@arm.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] x86: align x86 arch with generic CPU modalias handling
References: <1391014246-9715-1-git-send-email-ard.biesheuvel@linaro.org> <1391014246-9715-4-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1391014246-9715-4-git-send-email-ard.biesheuvel@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 08:50 AM, Ard Biesheuvel wrote:
> The x86 CPU feature modalias handling existed before it was reimplemented
> generically. This patch aligns the x86 handling so that it
> (a) reuses some more code that is now generic;
> (b) uses the generic format for the modalias module metadata entry, i.e., it
>     now uses 'cpu:type:x86,venVVVVfamFFFFmodMMMM:feature:,XXXX,YYYY' instead of
>     the 'x86cpu:vendor:VVVV:family:FFFF:model:MMMM:feature,XXXX,YYYY' that was
>     used before.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Looks good, although I have not tested it.

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa


