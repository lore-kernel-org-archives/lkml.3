Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbaLHLFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:05:44 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10917 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaLHLE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:04:56 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-e5-548585d5568f
Message-id: <548585C5.3000209@samsung.com>
Date: Mon, 08 Dec 2014 12:04:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v2 01/11] media: s3c-camif: use vb2_ops_wait_prepare/finish
 helper
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
 <1417041754-8714-2-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1417041754-8714-2-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t/xq7rXWltDDNaVWiz5uYvJ4vKuOWwW
	PRu2slq8vL+C2WLe551MDqweU35vZPXYOesuu8fnTXIBzFFuNhmpiSmpRQqpecn5KZl56bZK
	oSFuuhZKCnmJuam2ShG6viFBSgpliTmlQJ6RARpwcA5wD1bSt0twy1hwdyZLwRGWils/D7I0
	MD5i7mLk5JAQMJH4fW0rG4QtJnHh3nogm4tDSGApo8TGFZuZIZxPjBJ9k/exg1TxCmhJzDjz
	D6yDRUBV4uicK6wgNpuAoUTv0T5GEFtUIELi5N09UPWCEj8m32MBsUUEwiVWfL0PtplZoEZi
	6odmoDgHhzBQ/a+V8SBhIYFORomW+eUgNqeAl8Sb7jVsICXMAnoS9y9qQXTKS2xe85Z5AqPA
	LCQLZiFUzUJStYCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSLx82cG4+JjVIUYBDkYl
	Hl5zxdYQIdbEsuLK3EOMEhzMSiK8iXFAId6UxMqq1KL8+KLSnNTiQ4zJQO9PZJYSTc4HxnJe
	SbyhiaG5paGRsYWFuZERacJK4rwVX1tChATSE0tSs1NTC1KLYLYwcXBKNTA63Mhau/LuE660
	g03zudZx14fUieSqetlff/GYsfKvZHzAinL5p69SkvYVftygFHBqkuHdWj+bJgWluX/M5Q3F
	3/DE97bVh5650qJqXK4459rPL1t4jqx9XjKN5ZrzitWPL0Z7FfL+9vTcuU968Z1lCUZRSu8j
	d7B73FvKffTSI4uV10VZAq4osRRnJBpqMRcVJwIAQuMCpNsCAAA=
X-MTR: 20000000000000000@CPGS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 23:42, Lad, Prabhakar wrote:
> This patch drops driver specific wait_prepare() and
> wait_finish() callbacks from vb2_ops and instead uses
> the the helpers vb2_ops_wait_prepare/finish() provided
> by the vb2 core, the lock member of the queue needs
> to be initalized to a mutex so that vb2 helpers
> vb2_ops_wait_prepare/finish() can make use of it.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>


Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Thanks,
Sylwester
