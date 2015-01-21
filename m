Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbbAUH4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:56:31 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26558 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbAUH4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:56:20 -0500
X-AuditID: cbfee691-f79b86d000004a5a-82-54bf5b9589b1
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND 0/2] Add regulator-haptic device tree
Date: Wed, 21 Jan 2015 16:55:58 +0900
Message-id: <1421826960-26491-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsWyRsSkRHda9P4Qg41xFte/PGe12NFwhNWi
	//FrZoubn76xWlzeNYfNYsb5fUwObB6bVnWyefRtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfG
	9If97AUvWCqaOj6yNjD+YO5i5OSQEDCRmHz+JJQtJnHh3nq2LkYuDiGBpYwSK1ZdYIQpur1m
	BgtEYhGjxI/nr9ghnDYmic3Nf8Da2QS0Jb6vX8zaxcjBISKgKLF5gQJIDbPARkaJP9v6WEBq
	hAVsJJr+f2IDsVkEVCUWbj8C1ssr4CHxatF+JpBeCQEFiTmTbCAWv2aTuP3EFKJcQOLb5EMs
	ECWyEpsOQB0tKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEBuXpf88m
	7mC8f8D6EKMAB6MSD+8Lxf0hQqyJZcWVuYcYTYE2TGSWEk3OB4Z+Xkm8obGZkYWpiamxkbml
	mZI4r470z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjEUJol819PxXzi81nLyzX+3Mlaus
	M+cwie5UafvIlLJk1RYGKymVvm3ueo6xKyUYbWUY7pcxG3Wt/r+Rv3ODYfrkQI1/rM900td9
	qchmqmA/ft7y7+Tp7vxF2g843Z2nT3nofiDE9c1vr4Cc21uu8J+xMijQ3zhd2lxPKUjpZGbp
	slXtO/lClFiKMxINtZiLihMBlOEGlkUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jAd2p0ftDDOY/MbO4/uU5q8WOhiOs
	Fv2PXzNb3Pz0jdXi8q45bBYzzu9jcmDz2LSqk82jb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOmP+xnL3jBUtHU8ZG1gfEHcxcjJ4eEgInE7TUzWCBs
	MYkL99azdTFycQgJLGKU+PH8FTuE08Yksbn5D1gHm4C2xPf1i1m7GDk4RAQUJTYvUACpYRbY
	yCjxZ1sf2CRhARuJpv+f2EBsFgFViYXbj4D18gp4SLxatJ8JpFdCQEFiziSbCYzcCxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEh/0z6R2MqxosDjEKcDAq8fC+UNwfIsSaWFZcmXuI
	UYKDWUmEV1ECKMSbklhZlVqUH19UmpNafIjRFGj5RGYp0eR8YEzmlcQbGpuYGVkamRtaGBmb
	K4nzKtm3hQgJpCeWpGanphakFsH0MXFwSjUwqs5OdJ14Vcb7gPuTv4z+/XmMdw5PanEM9r67
	vJJ5Es8ihqhtzEczrC1O+AT6S8eKT+TwuPzZ4xybq33jLR+vTzfj9zzraf6zrGyjybm5ItpX
	qy78yglo8meTlJORNpkX4iV9uEfLa2tv817V/G0T0l7tmvKwR1jmd1VIdZZrcFEOU3nXXXkl
	luKMREMt5qLiRACM3wigkQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic device tree in rinato and monk boards.

The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

regualtor-haptic driver merged at linux-next
ref : https://lkml.org/lkml/2014/12/17/477

Jaewon Kim (2):
  ARM: dts: exynos3250-rinato: Add regulator-haptic node for haptics
  ARM: dts: exynos3250-monk: Add regulator-haptic node for haptics

 arch/arm/boot/dts/exynos3250-monk.dts   |    7 +++++++
 arch/arm/boot/dts/exynos3250-rinato.dts |    7 +++++++
 2 files changed, 14 insertions(+)

-- 
1.7.9.5

