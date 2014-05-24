Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaEXS5I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 14:57:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaEXS5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 14:57:07 -0400
Message-ID: <5380EB5C.7060903@zytor.com>
Date: Sat, 24 May 2014 11:56:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Pinski <apinski@cavium.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/24] ARM64:ILP32: The native siginfo is used instead
 of the compat siginfo.
References: <1400914939-9708-1-git-send-email-apinski@cavium.com> <1400914939-9708-22-git-send-email-apinski@cavium.com>
In-Reply-To: <1400914939-9708-22-git-send-email-apinski@cavium.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2014 12:02 AM, Andrew Pinski wrote:
>  
> +/* ILP32 uses the native siginfo and not the compat struct */
> +#define COMPAT_USE_NATIVE_SIGINFO	!is_a32_compat_task()
> +

<nitpick> Probably want parens around that expression? </nitpick>

	-hpa

