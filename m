Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbaD3J2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:28:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19769 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbaD3J2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:28:48 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-26-5360c24c71f1
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, t.figa@samsung.com
Subject: [PATCH 0/5 v3] iio: exynos_adc: fix minor nits in the driver
Date: Wed, 30 Apr 2014 14:56:50 +0530
Message-id: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkWtfnUEKwwap71hYvD2lanF12kM2i
	efF6NotXR34wWSyZPJ/VYt6RdywWl3fNYbOYcX4fk8Wibf+ZLdbPeM3iwOUxu+Eii8fOWXfZ
	PfbPXcPuseTNIVaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgynh5Yj9bwQrOilUTNjA2MF5m
	72Lk5JAQMJH4f6eDFcIWk7hwbz1bFyMXh5DAUkaJq+tuMMMUHbw5lRUiMZ1R4nbTHWYIp59J
	YsfemYwgVWwCZhIHF60GGsvBISIgKzGzWw+khlngCaPEjy2vwSYJC7hK3NzZwQZiswioSrzc
	vIsRpJ4XKP7+eCaIKSGgIDFnkg1Iq4TAInaJHzcXQ5ULSHybfIgFokZWYtMBqNskJQ6uuMEy
	gVFwASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzA0D7979nEHYz3D1gfYkwGGjeRWUo0
	OR8YG3kl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnV
	wNgWvqhb/mvonH1ORVpLHtjG9E2t3Rbbunzq66vds8zvlDwUu+6Wc4/JKiy/9eAEDz8mf+nW
	P5umacc8bdkSdvspZ7NAui+r+u7ZGTLrHN75O/xbfs55ZYDRvd3vVFnq7bK+di6Rf8pcvrtw
	lUVU0UGNPwk/pUtfz99tG/iNvTRKK1RYrLzDS4mlOCPRUIu5qDgRAMTkkmyDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t9jQV2fQwnBBlMuG1m8PKRpcXbZQTaL
	5sXr2SxeHfnBZLFk8nxWi3lH3rFYXN41h81ixvl9TBaLtv1ntlg/4zWLA5fH7IaLLB47Z91l
	99g/dw27x5I3h1g9+rasYvT4vEkugC2qgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhDWPGyxP72QpWcFasmrCBsYHxMnsXIyeHhICJxMGbU1khbDGJC/fWs3UxcnEICUxnlLjd
	dIcZwulnktixdyYjSBWbgJnEwUWrgbo5OEQEZCVmduuB1DALPGGU+LHlNTNIjbCAq8TNnR1s
	IDaLgKrEy827GEHqeYHi749ngpgSAgoScybZTGDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOHKeSe1gXNlgcYhRgINRiYdXYGt8sBBrYllxZe4hRgkOZiUR3oyOhGAh3pTEyqrU
	ovz4otKc1OJDjMlAuycyS4km5wOjOq8k3tDYxNzU2NTSxMLEzJI0YSVx3gOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGDkOdrgqTZBgfGRbc+vgn9onO1ovl7npHlSK9NXeee1fxP87YoavhbKk
	GK/5eDsl7mxeOP1Hn3Wg++uQK2kLGybKCK/iD3vYfM/QyWrJUZPYoJUPWPMOyFb7anFvnjHn
	3b9V+hZv9Luv93TK3fp8XbJw+ZloRccX7/W/5hewyW5IVDK49nq6qxJLcUaioRZzUXEiACjt
	hAjgAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the 
1. bug causing a crash during module removal for exynos_adc.ko.
-> The bug was seen by Doug, while trying to compile the whole IIO subsystem
   as module @ https://lkml.org/lkml/2014/4/21/481 from Doug.

2. rearrange the clock and regulator enable/disable calls during
   probe, remove, suspend and resume calls
-> Comments give by Jonathan @ https://lkml.org/lkml/2014/4/23/644

3. reduces the timeout and uses wait_for_completion_timeout instead of the
   interruptible varient.
-> This change was under review @ https://lkml.org/lkml/2013/11/5/92
   Final comments were given by Tomasz, to split and submit.

Naveen Krishna Ch (2):
  iio: exynos_adc: use indio_dev->dev structure to handle child nodes
  iio: exynos_adc: rearrange clk and regulator enable/disable calls

Naveen Krishna Chatradhi (3):
  iio: exynos_adc: reduce timeout and use wait_for_completion_timeout
  iio: exynos_adc: do a soft reset in case of timeout
  iio: exynos_adc: do a reinit_completion before the conversion

 drivers/iio/adc/exynos_adc.c |  137 +++++++++++++++++++++++-------------------
 1 file changed, 74 insertions(+), 63 deletions(-)

-- 
1.7.9.5

