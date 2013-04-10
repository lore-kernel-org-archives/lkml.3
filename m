Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964901Ab3DJIhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:37:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38012 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935214Ab3DJIhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:37:07 -0400
X-AuditID: cbfee68d-b7f786d000005188-b4-516524a12b36
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Alexander Shiyan'" <shc_work@mail.ru>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
References: <20130410171743.2ffa67388b330991228a6775@canb.auug.org.au>
In-reply-to: <20130410171743.2ffa67388b330991228a6775@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the arm-soc tree with the pm tree
Date: Wed, 10 Apr 2013 17:36:49 +0900
Message-id: <30ad01ce35c6$8b13cb10$a13b6130$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac41u4P+BTNP8d0TSO2buiUW6AYtGAAB2Stg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+Zge5CldRAgyuPDS3+TjrGbtG74Cqb
	xabH11gtLu+aw2ZxcGEbo8Wp65/ZLPoX9jJZbN17ld1i0g4pi41fPRy4PH7/msTo0XjjBpvH
	nWt72Dw2L6n3uHKiidVjytwjrB59W1Yxejxa3MLo8XmTXABnFJdNSmpOZllqkb5dAlfGxTOn
	WAv+cVQcWLyCpYFxDXsXIyeHhICJxIwrL1khbDGJC/fWs3UxcnEICSxjlDh15zQrTNGV1kus
	EInpjBIvZy1hgnD+MkrMmdIKVsUmoCFx+P0zdpCEiMBsRon/L/+DVTELbGOUWNu6kBmkSkjA
	TaJ18nUwm1PAXWLxmblghwgLeEns3TIRbBKLgKrEwcvzgZo5OHgFbCXWHTABCfMKCEr8mHyP
	BcRmFtCSWL/zOBOELS+xec1bZpByCQF1iUd/dUHCIgJGEj3Td0GViEjse/GOEeQcCYGFHBIt
	S15ArRKQ+Db5EAtEr6zEpgPMEB9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQ
	nJReZKhXnJhbXJqXrpecn7uJEZIAencw3j5gfYgxGWj9RGYp0eR8YALJK4k3NDYzsjA1MTU2
	Mrc0I01YSZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMj3x2Fz0kuf3QC5zV6vhXd
	+sn32bPirwuqEg3Df9svXiHGkTDT5o2svarL5oCzjK0X35++ILCI1XWn91sFRabvnPvrHyuv
	ZGlQTOrZHd81o8Q23isnO1z2A898JQ8Np9qbEQ8a100q4iif28ufdnv5oYYyB6ctVzPl1wmd
	YqlpivnFFCWwLUiJpTgj0VCLuag4EQBC9z4bFgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAKsWRmVeSWpSXmKPExsVy+t9jQd2FKqmBBnc7dS3+TjrGbtG74Cqb
	xabH11gtLu+aw2ZxcGEbo8Wp65/ZLPoX9jJZbN17ld1i0g4pi41fPRy4PH7/msTo0XjjBpvH
	nWt72Dw2L6n3uHKiidVjytwjrB59W1Yxejxa3MLo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZe
	uq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QnUoKZYk5pUChgMTiYiV9O0wTQkPc
	dC1gGiN0fUOC4HqMDNBAwjrGjItnTrEW/OOoOLB4BUsD4xr2LkZODgkBE4krrZdYIWwxiQv3
	1rN1MXJxCAlMZ5R4OWsJE4Tzl1FizpRWsCo2AQ2Jw++fsYMkRARmM0r8f/kfrIpZYBujxNrW
	hcwgVUICbhKtk6+D2ZwC7hKLz8wF2ycs4CWxd8tEsEksAqoSBy/PB2rm4OAVsJVYd8AEJMwr
	ICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmUHKJQTUJR791QUJiwgYSfRM3wVVIiKx78U7xgmM
	QrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4vTyT3sG4qsHi
	EKMAB6MSD+8Cw5RAIdbEsuLK3EOMEhzMSiK8N78DhXhTEiurUovy44tKc1KLDzEmA/05kVlK
	NDkfmPrySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHRXc5r
	68wpX5eJ7N3nlX9vb5pfvpqdvNBJXQux5zlPfhl+kZx2zsDmZVnsj8giKam3Gq6z/k2dLfh/
	y1KJvY8tNjRf2v0yyIP517b5Wqn3w2tj+UNWBfw8WrH8pdtuTa2ry7dc8JOynL7yRq4Ry+O/
	ry/Pmtd5Ztcymz+pUbaeJVHMlwzcWnJ2KbEUZyQaajEXFScCAABKbKZzAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi all,
> 
Hi,

> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-s3c24xx/Kconfig between commit 785f40040874 ("cpufreq:
> s3c24xx: move cpufreq driver to drivers/cpufreq") from the pm tree and

As I know, Rafael will drop it in his tree.
http://lists-archives.com/linux-kernel/27815851-cpufreq-s3c24xx-move-cpufreq
-driver-to-drivers-cpufreq.html

> commits fb278af74b28 ("ARM: S3C24XX: Removed unneeded dependency on
> CPU_S3C2410") and a4e4d22c6f53 ("ARM: S3C24XX: Removed unneeded
> dependency on CPU_S3C2412") from the arm-soc tree.
> 
> I fixed it up by removing the sections from arch/arm/mach-s3c24xx/Kconfig
> and can carry thefix as necessary (no action is required).
> 
Thanks.

> P.S. those arm-soc tree commits have a bad Author email address ...

Oops :-( it's my fault due to e-mail client problem...

Arnd, it happened in next/dt-exynos, next/mct-exynos and
next/cleanup-samsung branches in my tree.

And I sorted out in my local just now. Could you please re-pull them into
arm-soc? Then, I will push forced. Sorry about that.

- Kukjin

