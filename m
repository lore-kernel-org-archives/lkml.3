Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab3IBKJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:09:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10463 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3IBKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:09:21 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-4e-522463cf07bc
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, "'Mark Brown'" <broonie@linaro.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
 <1377948564-8383-5-git-send-email-broonie@kernel.org>
In-reply-to: <1377948564-8383-5-git-send-email-broonie@kernel.org>
Subject: RE: [PATCH 05/11] regulator: s5m8767: Covert to
 devm_regulator_register()
Date: Mon, 02 Sep 2013 19:09:18 +0900
Message-id: <0bfd01cea7c4$7cdc8b20$7695a160$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHQ0M3pMhjX+2mLni6L+4Gx2JAHTwHjj4sXmZ7KoeA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI93zySpBBgs6rCymPnzCZrHp+nVW
	i29XOpgs3h96xmxxedccNovlb/+zObB57Jx1l91j06pONo871/awedz+95jZ4+XE32wenzfJ
	BbBFcdmkpOZklqUW6dslcGW0TH/OUrCDqeJL+2PWBsYGpi5GTg4JAROJcyteskHYYhIX7q0H
	srk4hASWMUo8/LcNrujxugeMEIlFjBL7F82CqvrDKNF5qIUZpIpNQENi5e63YKNEBHwkrl9f
	wQ5SxCzQxSjxf+d0VpCEkEClxNQtF9hBbE4BJ4lJD1eANQsLhEicPbYFqJmDg0VAVeLVgzoQ
	k1fAUuLEw2CQCl4BQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHGogsSOs68ZIU6wkui6tJoZ
	okZEYt+Ld2APSAh8ZZdYcm8l2J0sAgIS3yYfYgHZJSEgK7HpANQcSYmDK26wTGCUmIVk9Swk
	q2chWT0LyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MULit3cH4+0D1ocYk4HWT2SW
	Ek3OB8Z/Xkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYe5lrWJdvdRLwibYI3WlzyaS71cxhMdsZua+edtZbgs1LHDirFj7/xP61zuRyKTPzy/U8
	OXnyos0SKuzXUm/PvJVmvmbOpS+ymjx32VzfKzTFzpbfZf9t74/VK1f+WedS+vbQvW3Zynwd
	K98+OCu/PI7N3PPxRSXe2b76BgcipPvlfu5pqA5QYinOSDTUYi4qTgQA2UL6sPUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd3zySpBBvMmmllMffiEzWLT9eus
	Ft+udDBZvD/0jNni8q45bBbL3/5nc2Dz2DnrLrvHplWdbB53ru1h87j97zGzx8uJv9k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0TL9OUvBDqaKL+2PWRsY
	G5i6GDk5JARMJB6ve8AIYYtJXLi3nq2LkYtDSGARo8T+RbOgnD+MEp2HWphBqtgENCRW7n7L
	BmKLCPhIXL++gh2kiFmgi1Hi/87prCAJIYFKialbLrCD2JwCThKTHq4AaxYWCJE4e2wLUDMH
	B4uAqsSrB3UgJq+ApcSJh8EgFbwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeJQBYkdZ18z
	QpxgJdF1aTUzRI2IxL4X7xgnMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4OTwTGoH48oGi0OMAhyMSjy8FSuUg4RYE8uKK3MPMUpwMCuJ8D5iVgkS4k1J
	rKxKLcqPLyrNSS0+xJgM9OdEZinR5Hxg4soriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBsbZihdTXH4djlQvP/KqdSfn5FCWvdZi17meLQ3vPSBdPCkwuPBT
	7IF3kqUW65e1Os7pqJf6aGi5zDY7a2looP/+7lqv9/eu3K68PP3VFL4ZShmeilk/NjBybz/M
	Er9ky65yPb3++zrL7xS9Fnb12rHU8JJxONsvj32fnQz4RBdWrZq+OqJIgVGJpTgj0VCLuag4
	EQAixzNTUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 31, 2013 8:29 AM, Mark Brown wrote:

> Subject: [PATCH 05/11] regulator: s5m8767: Covert to devm_regulator_register()
> 
> From: Mark Brown <broonie@linaro.org>
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

