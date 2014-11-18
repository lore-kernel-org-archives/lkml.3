Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaKRAkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:40:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39574 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaKRAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:40:33 -0500
X-AuditID: cbfee68f-f791c6d000004834-90-546a957f5b22
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sameo@linux.intel.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-6-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH 5/5] mfd: s2mps11: Add binding documentation for Samsung
 S2MPS13 PMIC
Date: Tue, 18 Nov 2014 09:40:31 +0900
Message-id: <012501d002c8$41b107a0$c51316e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBIGxsMOaDFXn+jUEunj34K9G6SgCZVrFZm/6EouA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkTbd+alaIwcklChZLLl5lt5j68Amb
	xfUvz1kt5h85x2rxZ0Irm8Wk+xNYLM42vWG3uP/1KKPFtysdTBaXd81hs3g64SKbxeluVgce
	j52z7rJ7bFrVyeZx59oeNo95JwM9+rasYvSYPu8nk8fnTXIB7FFcNimpOZllqUX6dglcGVsO
	3GAuuMZUsf/VT8YGxmlMXYycHBICJhKz78+CssUkLtxbzwZiCwksZZRY1qMPU7Nk+nv2LkYu
	oPgiRomtt15DOb8ZJe62PmEHqWIT0JBYufstG0hCRKCZUWLn9TcsIA6zwDZGiQl/T7FDzK2V
	+PHzNyOIzSngIrFg916gDg4OYYFoiYv/RUHCLAKqEv9XnmYGsXkFLCU2HbrJBmELSvyYfI8F
	xGYW0JJYv/M4E4QtL7F5zVtmiFMVJHacfQ02XkTASmLe3x9Q9SIS+168YwS5R0JgIYfEthn3
	GSGWCUh8m3yIBeQGCQFZiU0HoOZIShxccYNlAqPELCSrZyFZPQvJ6llIVixgZFnFKJpakFxQ
	nJReZKxXnJhbXJqXrpecn7uJEZgCTv971r+D8e4B60OMAhyMSjy8O7IzQ4RYE8uKK3MPMZoC
	XTSRWUo0OR+YaPJK4g2NzYwsTE1MjY3MLc2UxHkXSv0MFhJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cBYOPPh4X/Kpzcr3woU/9s9oXHlBqbWY6b+nZOrQn+Usa6ddpTbLeZl25yst4dyVd0+
	8ExZuz1c/ZPuocSrFi4vr0psMt3kKCO0du/SRT3bKm6wH3u1LqA57U77qt3R4gd6a3OP7n/+
	usH/3vkp0/71TXgazSVtl97zpSFHZU3LvvsbGFYYfPu1UYmlOCPRUIu5qDgRACa3Brv8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd36qVkhBh+fSlssuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WR14
	PHbOusvusWlVJ5vHnWt72DzmnQz06NuyitFj+ryfTB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8zYcuAGc8E1por9r34yNjBOY+pi5OSQEDCRWDL9PTuELSZx
	4d56ti5GLg4hgUWMEltvvWaHcH4zStxtfQJWxSagIbFy91uwKhGBZkaJndffsIA4zALbGCUm
	/D0FViUkUCvx4+dvRhCbU8BFYsHuvUAdHBzCAtESF/+LgoRZBFQl/q88zQxi8wpYSmw6dJMN
	whaU+DH5HguIzSygJbF+53EmCFteYvOat8wQpypI7Dj7Gmy8iICVxLy/P6DqRST2vXjHOIFR
	aBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSnmGfSOxhXNVgc
	YhTgYFTi4d2RnRkixJpYVlyZe4hRgoNZSYT3XHdWiBBvSmJlVWpRfnxRaU5q8SFGU6BPJzJL
	iSbnA9NfXkm8obGJmZGlkZmFkYm5uZI478FW60AhgfTEktTs1NSC1CKYPiYOTqkGxl7+aT/f
	507Z7TNt0fyq6xP+hpyO9dkuNf9A9dEdCxMc107btCQwgY2Pq2OftG+VQcetQxzq21ImPBUW
	cbh9YMPF3pZbTUuZSnMFEzUe75Re9OmAy56mW5tE9FMnd+3/feEGz+pJX1VnMC63Cl8f/TIk
	1Tc/4V727ocq++7/PZT2/xBXn9YPyVNKLMUZiYZazEXFiQDj3n7vRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:
> This patch adds the binding documentation for Samsung S2MPS13 PMIC
> which is similiar with existing S2MPS14 PMIC. S2MPS13 has the different number
> of regulators from S2MPS14 and RTC/Clock is the same with the S2MPS14.


Acked-by: Sangbeom Kim <sbkim73@samsung.com>

