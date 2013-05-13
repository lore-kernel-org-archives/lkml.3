Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab3EMEHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 00:07:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34249 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3EMEHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 00:07:20 -0400
X-AuditID: cbfee690-b7efc6d000006d92-5a-519066f6683c
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Dolev Raviv'" <draviv@codeaurora.org>, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Santosh Y'" <santoshsy@gmail.com>
References: <1368368640-10167-1-git-send-email-draviv@codeaurora.org>
 <1368368640-10167-4-git-send-email-draviv@codeaurora.org>
In-reply-to: <1368368640-10167-4-git-send-email-draviv@codeaurora.org>
Subject: RE: [PATCH V1 3/8] scsi: ufs: wrap the i/o access operations
Date: Mon, 13 May 2013 13:07:17 +0900
Message-id: <002301ce4f8f$5bc02600$13407200$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac5PHOr24XezpGorSfaGQlTKhExNsQAX5w9w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI91vaRMCDbovylqcPdPPZDFx/1l2
	i8u75rBZdF/fwWZxcO4ZdgdWj8t9vUweO2fdZff4vEkugDmKyyYlNSezLLVI3y6BK2PHvx62
	glaWiplHrrA3MK5m7mLk5JAQMJH4fPUjlC0mceHeerYuRi4OIYFljBK9s1vYYYqa9l6GSkxn
	lDhzZi+U84dRYsH/m2BVbAJaEn/fvAEbJSLgKnH+8ys2EJtZoEhi2rUZ7BANjYwSHV96mEAS
	nAJuEluWrGDpYuTgEAZq2HDXHSTMIqAq8XL5aRYQm1fAVmLtix2MELagxI/J98DKmQXUJaZM
	yYUYLy+xec1bZpCwBFD40V9dEFNEwEji9qlaiAoRiX0v3jGCHCAhcIxd4sPE3cwQmwQkvk0+
	xALRKiux6QA0HCQlDq64wTKBUWIWkr2zEPbOQrJ3FpINCxhZVjGKphYkFxQnpReZ6BUn5haX
	5qXrJefnbmKEROSEHYz3DlgfYkwG2j6RWUo0OR8Y0Xkl8YbGZkYWpiamxkbmlmakCSuJ86q3
	WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBQMdbreZ+O6Z2LVvJjrE9faLWP+pjj5kOxK
	f40nFwNr36rxbbP0VdJbbZrOz1q2Ncn9Sab3WtauA7FG37v+Gsb9e3/zxyNX7u/dE08+0Z4d
	/iiA907us7abaVUXFpc/WtCqYGVU4fBgZcD+A9aSNhpajvm+IZJL9seyi7tdCv7qJ3Xn4oof
	JUosxRmJhlrMRcWJAHTr8lHeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd1vaRMCDX4ckbQ4e6afyWLi/rPs
	Fpd3zWGz6L6+g83i4Nwz7A6sHpf7epk8ds66y+7xeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGjn89bAWtLBUzj1xhb2BczdzFyMkhIWAi0bT3MhuELSZx4d56
	IJuLQ0hgOqPEmTN7oZw/jBIL/t9kB6liE9CS+PvmDVi3iICrxPnPr8C6mQWKJKZdm8EO0dDI
	KNHxpYcJJMEp4CaxZckKli5GDg5hoIYNd91BwiwCqhIvl59mAbF5BWwl1r7YwQhhC0r8mHwP
	rJxZQF1iypRciPHyEpvXvGUGCUsAhR/91QUxRQSMJG6fqoWoEJHY9+Id4wRGoVlI5sxCmDML
	yZxZSDoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO92fSOxhXNVgcYhTgYFTi4fVQ
	nBAoxJpYVlyZe4hRgoNZSYR3rxtQiDclsbIqtSg/vqg0J7X4EGMy0JcTmaVEk/OBqSivJN7Q
	2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgVdIxlU9zDHv8pZxVe
	67DtrNDeR7F50/TCcqZ8z17pKOoSaJFrps1gtUG8773iJ0HbAtUNkw2uM2c+UnVRqzE8rHi5
	PDCuodE9Xixb6HDCBY/rs7c757Y/CF9+PfGx2SWeiZFiXCc5lBdydd7h8nzy0Xz9PIkXm+OM
	/frWtdanN7tdOfX+kBJLcUaioRZzUXEiAI0izM07AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, May 12, 2013, Dolev Raviv wrote:
Author should be identified here. (From: author...)
Except last patch of series(8/8), all of patches are not from you.

> Simplify operations with hiding mmio_base.
> 
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
I'm not sure that your signed-off is proper here including (3/8 ~ 6/8)
And maintainer, Santosh's ack is omitted.

> Tested-by: Maya Erez <merez@codeaurora.org>
Thanks,
Seungwon Jeon

