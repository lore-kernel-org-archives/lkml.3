Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089AbaE2Iwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:52:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:53405 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934066AbaE2Iwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:52:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-a1-5386f55acd20
Content-transfer-encoding: 8BIT
Message-id: <1401353566.25628.11.camel@AMDC1943>
Subject: Re: [PATCH 3/4] regulator: s2mps11: Set offset to voltage hexadecimal
 code of S2MPU02 LDO regulators
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com
Date: Thu, 29 May 2014 10:52:46 +0200
In-reply-to: <1401275411-21947-4-git-send-email-cw00.choi@samsung.com>
References: <1401275411-21947-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xa7pRX9uCDZqvmVlMffiEzeL6l+es
	Fp1nnzBbnG16w25x/+tRRotvVzqYLC7vmsNmcbtxBZvF6W5Wi4srvjA5cHnsnHWX3WPTqk42
	jzvX9rB5zDsZ6NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZz95OYSq4yFrxd0UXUwPjCZYu
	Rg4OCQETiUkzJbsYOYFMMYkL99azdTFycQgJLGWUONVxhQkkwSsgKPFj8j2wemYBeYkjl7JB
	wswC6hKT5i1ihqj/DFR/8DYbRL2BxJsp5xhBbGGBfInuox1gcTYBY4nNy5eA2SICGhIz/15h
	BGlmFrjHKLHy7RRmkASLgKrE8dVrwWxOATeJpReOsYDYQgKuEo++rWeGuFRZYt7+Y0wTGAVm
	IblvFsJ9s5Dct4CReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSBx82cG4+JjVIUYBDkYl
	Ht6I0LZgIdbEsuLK3EOMEhzMSiK8ny4BhXhTEiurUovy44tKc1KLDzEycXBKNTDG2Xaameyq
	UA34o1RToiw79/ur0ub8hoJUwfiq9dPnr17HySLpmb4p4cEjsW/W09u+MGuIZQb8E2lPsdjK
	4nZ497oTAa+Ybj9fXdUQo8meM/FJ0vY1ov8EFewdbM41frJvYOf6nh3J8zph+s0C2UqrE4vL
	vyds51tc5SYrfEslZluezvqF15RYijMSDbWYi4oTAe7IRedhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-05-28 at 20:10 +0900, Chanwoo Choi wrote:
> From: Jonghwa Lee <jonghwa3.lee@samsung.com>
> 
> Different with s2mps1x series, s2mpus02's LDO has offset in voltage hexadecimal
> code, which is used as in selector in regulator subsystem. It means the value of
> minimum voltage is not start with 0x0, but has certain offset.
> (as like BUCK regulator in both of s2mps1x and s2mpu02)
> 
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Does it mean that driver from previous patch (2/4) does not work
correctly and the git history is not bisectable? If so than this patch
should be squashed with 2/4.

Best regards,
Krzysztof



