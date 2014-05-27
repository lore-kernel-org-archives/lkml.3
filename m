Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaE0Aj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:39:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49440 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaE0AjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:39:25 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-36-5383debbaaf1
Message-id: <5383DED8.40500@samsung.com>
Date: Tue, 27 May 2014 09:39:52 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Sunghwan Yun <sunghwan.yun@samsung.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] staging: ion: remove struct ion_page_pool_item
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401098701-24049-4-git-send-email-heesub.shin@samsung.com>
In-reply-to: <1401098701-24049-4-git-send-email-heesub.shin@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zTd3d95qDDR5/FrB4//c+m8X2jd9Y
	LV4e0rQ4+OE+i8WeM7/YLZoXr2ezODh7CZPFmd+6Fpd3zWGzWDt/G5vFjcmFFqc7FrE68Hhs
	272N1eNyXy+Tx719h1k8ds66y+5x59oeNo/9c9ewe/RtWcXo8XmTXABHFJdNSmpOZllqkb5d
	AldGW3NEwRmmilX7WBsY25i6GDk5JARMJB5ve8oIYYtJXLi3nq2LkYtDSGAZo8T5c/fZYYpO
	7D7ADJFYxCjR2fsVLCEk8IZRYubpVBCbV0BD4vutLrBJLAKqEgsuLgayOTjYBLQlDm0LBgmL
	CkRI3Gs8zApRLijxY/I9FhBbRMBYov/sLHaQ+cwCn5gkbixtApsvLOAusXv5SaiLWhklXty9
	C5bgFPCQaO/9zwxiMwtYS6yctI0RwpaX2LzmLdilEgKdHBI7Zn2AukhA4tvkQywgF0kIyEps
	OsAM8ZmkxMEVN1gmMIrNQnLULCRjZyEZu4CReRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZG
	SPxO3MF4/4D1IcZkoJUTmaVEk/OB8Z9XEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU
	7NTUgtSi+KLSnNTiQ4xMHJxSDYzC9qLbNgYxNLUdP3H/WbRDduF316pZH9SFWColprdoPr/f
	8fxzRLyMkOvK/9u/Klmotr4/cu9qsPq936E75qnKJLHnXX7duEdXS988+Lm6skjUu4nLTjyN
	ld5f5f3MyTHKyqr6iJx+x5bduVeemYbk8tYWp73+mnrj2v3/P5fyZ1m9+/W294ASS3FGoqEW
	c1FxIgAIKIc09QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd3d95qDDd7s5LF4//c+m8X2jd9Y
	LV4e0rQ4+OE+i8WeM7/YLZoXr2ezODh7CZPFmd+6Fpd3zWGzWDt/G5vFjcmFFqc7FrE68Hhs
	272N1eNyXy+Tx719h1k8ds66y+5x59oeNo/9c9ewe/RtWcXo8XmTXABHVAOjTUZqYkpqkUJq
	XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QsUoKZYk5pUChgMTiYiV9
	O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjLbmiIIzTBWr9rE2MLYxdTFyckgImEic2H2AGcIW
	k7hwbz1bFyMXh5DAIkaJzt6v7CAJIYE3jBIzT6eC2LwCGhLfb3UxgtgsAqoSCy4uBrI5ONgE
	tCUObQsGCYsKREjcazzMClEuKPFj8j0WEFtEwFii/+wsdpD5zAKfmCRuLG0Cmy8s4C6xe/lJ
	qMWtjBIv7t4FS3AKeEi09/4Hu45ZwFpi5aRtjBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYwMq9i
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4Oz6R3MK5qsDjEKMDBqMTDO8G3OViINbGsuDL3
	EKMEB7OSCO+Gk0Ah3pTEyqrUovz4otKc1OJDjMnAIJjILCWanA9MXHkl8YbGJmZGlkZmxibm
	xsakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwCjiZKW3ZsHKnn+88cffnLO+Wls/xURd
	P9j0mL+OcNb/srBzXw893ZC2OCf2Qem7u/zfZT6EObHe7q1ef+HwHqFQ68jr+Z6btyrHTYqS
	VdvkYPTh8pf3YU7yxnzF1/5Ovli6/q3XmW1MNs2Z2xInlD7QtXN+N+v4RRunun/n0u75rghN
	/6y+XVyJpTgj0VCLuag4EQCVACHKUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/26/2014 07:04 PM, Heesub Shin wrote:
> Now that the order information is held on struct page itself, we do not
> need to use extra data structure. This commit reduces unnecessary slab
> usage for allocating small objects.
>

Oops. I need to amend changelog above and resend this patchset.

regards,
Heesub
