Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaKRA3C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:29:02 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51291 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKRA27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:28:59 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-e9-546a92c9bbdc
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sameo@linux.intel.com, geunsik.lim@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
Subject: RE: [PATCH 2/5] regulator: s2mps11: Add support S2MPS13 regulator
 device
Date: Tue, 18 Nov 2014 09:28:57 +0900
Message-id: <012301d002c6$a4289e90$ec79dbb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIBIGxsMOaDFXn+jUEunj34K9G6SgGzcbhDm/WwabA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkVffkpKwQg32bdCyWXLzKbjH14RM2
	i+tfnrNazD9yjtXiz4RWNotJ9yewWJxtesNucf/rUUaLb1c6mCwu75rDZvF0wkU2i9PdrA48
	Hjtn3WX32LSqk83jzrU9bB7zTgZ69G1Zxegxfd5PJo/Pm+QC2KO4bFJSczLLUov07RK4Mv6e
	/MRScJKpYskq9wbGCUxdjJwcEgImEjfbtjBD2GISF+6tZ+ti5OIQEljKKPHkxiw2mKLzR9dB
	JaYzSqxuX8IC4fxmlFj0ZjcLSBWbgIbEyt1vwapEBJoZJXZefwNWxSywjVFiwt9T7CBVQgK1
	EpcWNoDZnAIuEvuanrGC2MICwRJLjr0Cs1kEVCUOr1kHNpVXwFJizs/pzBC2oMSPyffA4swC
	WhLrdx5ngrDlJTaveQv1hILEjrOvGUFsEQEriYXnl0HViEjse/GOEeQgCYGZHBKfd15jg1gm
	IPFt8iGgoRxACVmJTQeg5khKHFxxg2UCo8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5k
	olecmFtcmpeul5yfu4kRmARO/3s2YQfjvQPWhxgFOBiVeHh3ZGeGCLEmlhVX5h5iNAW6aCKz
	lGhyPjDV5JXEGxqbGVmYmpgaG5lbmimJ876W+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gbF6uxpTxKrbQU//7ZvJ8fDFSSu2jz+u3Kzu9Aqa0MS7PeGJ+nqz9E3Nu0R3eK3ZLxI1vcD7
	6qVrS3n8zhu+k6zVrlmiHHD7Qc7qzqeH22xLj3vFdnPNUheYH3xb9rds3rILRwzqSsu4PR4u
	/P7Sc8KqxLinpdL1uezvT+7aH/Hc6o/nh29yz/iUWIozEg21mIuKEwFU7Y4k/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2Tk7JCDG60a1gsuXiV3WLqwyds
	Fte/PGe1mH/kHKvFnwmtbBaT7k9gsTjb9Ibd4v7Xo4wW3650MFlc3jWHzeLphItsFqe7WR14
	PHbOusvusWlVJ5vHnWt72DzmnQz06NuyitFj+ryfTB6fN8kFsEc1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsY8z4e/ITS8FJpoolq9wbGCcwdTFyckgImEicP7qODcIWk7hw
	bz2QzcUhJDCdUWJ1+xIWCOc3o8SiN7tZQKrYBDQkVu5+C1YlItDMKLHz+huwKmaBbYwSE/6e
	YgepEhKolbi0sAHM5hRwkdjX9IwVxBYWCJZYcuwVmM0ioCpxeM06sKm8ApYSc35OZ4awBSV+
	TL4HFmcW0JJYv/M4E4QtL7F5zVtmiFsVJHacfc0IYosIWEksPL8MqkZEYt+Ld4wTGIVmIRk1
	C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcIp5Jr2DcVWDxSFGAQ5G
	JR7eHdmZIUKsiWXFlbmHGCU4mJVEeM91Z4UI8aYkVlalFuXHF5XmpBYfYjQF+nQis5Rocj4w
	/eWVxBsam5gZWRqZWRiZmJsrifMebLUOFBJITyxJzU5NLUgtgulj4uCUamBMfpVR17L1l9T5
	uWZtDAZv6xY946iye3DthMzrrx/WJMaxzFAP/W5mcDvhRTXDAa9LL2LXT1ywoq/9vCyn8EOz
	xpn8kWVtwUHX1O3/pEntfLp/89+5H0J1nwemv453nCK/6dNvU/sthffLrC0256V/fRlWbfPx
	2aHwYMM4zQSPuVZrxBoDLuoqsRRnJBpqMRcVJwIAVgSGFkcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Monday, November 17, 2014 9:43 AM, Chanwoo Choi wrote:
> This patch adds S2MPS13 regulator device to existing S2MPS11 device driver.
> The S2MPS13 has just different number of regulators from S2MPS14.
> The S2MPS13 regulator device includes LDO[1-40] and BUCK[1-10].

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

