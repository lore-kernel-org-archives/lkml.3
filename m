Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaKDJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:25:29 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54270 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaKDJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:25:26 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-33-54589b8383b7
Message-id: <1415093122.2389.15.camel@AMDC1943>
Subject: Re: [PATCH 0/6] regulator: max77686/802: Cleanup
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Tue, 04 Nov 2014 10:25:22 +0100
In-reply-to: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t/xq7rNsyNCDOa3y1tsnLGe1WLqwyds
	Fkd/F1icbXrDbnH/61FGi29XOpgsLu+aw2ax9shddovT3awOnB5/n19n8dg56y67x6ZVnWwe
	d67tYfOYdzLQo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDLeXGxnK3jDVrF63nPmBsZdrF2M
	nBwSAiYS27bsZYewxSQu3FvP1sXIxSEksJRR4vbRb0wQzmdGidWfNjOCVPEK6Ets2H0ZrENY
	wFLi7f5mFhCbTcBYYvPyJUDdHBwiAhoSe3tqQHqZBe4wSexp6WcGqWERUJVoXH2PBaSGU8BD
	4n43WFhIwF2iaf0isDHMAuoSk+YtYgYpkRBQlmjsd4PYKijxY/I9qBJ5ic1r3jJPYBSYhaRj
	FpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIiYIvOxgXH7M6xCjAwajEw5uh
	HhEixJpYVlyZe4hRgoNZSYR3dRVQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2Ppk+dbpd+u9Ij5
	HPtn9p1uk18vl01SiJvQ+1vXxvTO54tzNtczHn9dfHHf4fqyA3/t291Nl7z/mrMw75a5zi3P
	izPnvEuaf2jGsmeGXilPDn8Ks1SQCV8hZXF4ukqSv9feoLK9jBNe+aaKTpCb3Lf3S37+8jfb
	3JR3627pKfv+aKLcmcTLy5fvUmIpzkg01GIuKk4EABC9YIJgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 09:49 +0100, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> Previously this patchset was part of adding GPIO to max77686
> regulator driver [1]. I split it but the goal is the same:
> cleanup and simplify the regulator drivers by removing obsolete
> board file support so adding new features would be easier.
> 
> The patchset removes board file support from regulator drivers
> incrementally and in a bisect-friendly way. Thus MFD driver is
> updated at the end.
> 
> Everything should be pulled at once (preferrably regulator tree).
> Rebased on next-20141031.

Probably I should rebase it on newer next or regulator tree because
yesterdays Javier's changes were applied. The merge conflict is trivial
to solve (only removal of lines).

Mark, let me know if you want me to resubmit because of the conflict.

Best regards,
Krzysztof

