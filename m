Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657AbaKTNc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 08:32:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58085 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbaKTNcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 08:32:24 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ab-546ded661a3b
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 0/2] Add regulator-haptic driver
Date: Thu, 20 Nov 2014 22:31:38 +0900
Message-id: <1416490300-28865-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJLMWRmVeSWpSXmKPExsWyRsSkSDftbW6IwdkHshbXvzxntTi86AWj
	xY6GI6wWvQuuslnc/PSN1eLyrjlsFjPO72NyYPfYOesuu0ffllWMHp83yQUwR3HZpKTmZJal
	FunbJXBlbH9wjaVgI1vFh6Y9TA2MH1i6GDk5JARMJPbf2gFli0lcuLeerYuRi0NIYCmjxKWn
	TawwRTOfrGYHsYUEpjNKdPxTgChqY5L4/u08WDebgLbE9/WLwRpEBEIlel9/ZgcpYhbYyCjx
	dc4NsISwgIHEpV/fwBpYBFQlmi80gsV5BTwknh17AbSaA2ibgsScSTYgvRIC79kk3t+EuIJF
	QEDi2+RDLBA1shKbDjBDHCcpcXDFDZYJjIILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+du
	YgSG6Ol/zybuYLx/wPoQowAHoxIPb4JFbogQa2JZcWXuIUZToA0TmaVEk/OBkZBXEm9obGZk
	YWpiamxkbmmmJM6rI/0zWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjmqvTv1vqv5taJPhP
	SYR+OOL089XOH1J3FNf8eKk7X/PWojNPrhkWXv65R/D+rvpyAV1P55sa39ItpQOld/xj3pXR
	IGS//5/g/bOTQooydor/Dms12s3+RZFX0dy2X2xvczDD0v1rN8x81rJ+l981rmtKEjqdazVO
	P5b1eHs/Zx9v7POulQtqlFiKMxINtZiLihMBN+UcPEwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xoG7a29wQg5O7xSyuf3nOanF40QtG
	ix0NR1gtehdcZbO4+ekbq8XlXXPYLGac38fkwO6xc9Zddo++LasYPT5vkgtgjmpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzNj+4BpLwUa2ig9Ne5gaGD+wdDFyckgImEjM
	fLKaHcIWk7hwbz0biC0kMJ1RouOfQhcjF5DdxiTx/dt5sAY2AW2J7+sXs4LYIgKhEr2vP7OD
	FDELbGSU+DrnBlhCWMBA4tKvb2ANLAKqEs0XGsHivAIeEs+OvQDawAG0TUFiziSbCYzcCxgZ
	VjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER8AzqR2MKxssDjEKcDAq8fAmWOSGCLEmlhVX
	5h5ilOBgVhLh1dgJFOJNSaysSi3Kjy8qzUktPsRoCrR8IrOUaHI+MDrzSuINjU3MjCyNzA0t
	jIzNlcR5b9wEahJITyxJzU5NLUgtgulj4uCUamBc+pJ1geuNQ06Fe3Ysf+B6cbtk6STW5U8+
	1W2sY0ifsWs/+72zugzvyqOvL7yQztjg2tO52EGjau/ErX+FFMxtbUMPPvJTXVs9MfVfwp/t
	hsGfZZtfX9+rsohny5MVwvI6XPrXeo5kzD3rt0L6meacnWJMVg+r/71cc+iA/Pl3AUt51erq
	Xx4SU2Ipzkg01GIuKk4EAF25Ar6WAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Jaewon Kim (2):
  Input: add regulator haptic driver
  ARM: dts: Add regulator-haptic device node for exynos3250-rinato

 .../devicetree/bindings/input/regulator-haptic.txt |   24 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |    7 +
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  241 ++++++++++++++++++++
 5 files changed, 284 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c

-- 
1.7.9.5

