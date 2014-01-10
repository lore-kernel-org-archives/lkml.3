Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbaAJQFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:05:08 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51182 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaAJQFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:05:01 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-bd-52d01a2bf66a
Message-id: <52D01A24.10603@samsung.com>
Date: Fri, 10 Jan 2014 17:04:52 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com
Subject: Re: [PATCH 8/8 v3] crypto:s5p-sss: Use clk_prepare/clk_unprepare
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xK7raUheCDL5vE7O4+/wwo8XLQ5oW
	3a9kLO7f+8lkcXnXHDaLGef3MVks2vaf2WLVrj+MFmfnHGJy4PTYOesuu8e2A6oefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlXH5zgrmghfMFQvb9rE0MHYwdzFyckgImEj0rnvMAmGLSVy4
	t56ti5GLQ0hgKaPEy0Wr2CGcz4wSK3e+BevgFdCQ6P7ykwnEZhFQlVh97wQjiM0moCbxueER
	G4gtKhAh8XfeekaIekGJH5PvgW0QESiX+HdjDdgGZoE5jBIPl7SDJYQFPCWWPl8NZgsJuEo8
	nDqBFcTmFHCTuD/jFVicWcBaYuWkbYwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRNLU0u
	KE5KzzXUK07MLS7NS9dLzs/dxAgJ9i87GBcfszrEKMDBqMTDGyByIUiINbGsuDL3EKMEB7OS
	CO81QaAQb0piZVVqUX58UWlOavEhRiYOTqkGRieXt47nNptNuiErxM7M1md8+Pnzz03Nk5ad
	FKrf/vSHoXjbY4bayJwnc9Z1xc+fceGydciHa/0LFr3rnGK5Y3aYLdeNgH8xS/aIvFtb+Pyg
	iWxUo/vSpmoZo4AGX85DO+OuL1Bdll05kW/RUt3JoXciWKfwrFgou19XU4P7p9Dn9pMpHr3h
	s5VYijMSDbWYi4oTATSDLz1UAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 12:45, Naveen Krishna Chatradhi wrote:
> This patch set adds use of clk_prepare/clk_unprepare as
> required by generic clock framework.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v2:
> New change to fix a WARN_ON during the bootup
>
>   drivers/crypto/s5p-sss.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
