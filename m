Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbaD3N0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:26:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39104 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbaD3N0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:26:53 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-49-5360fa1a2203
Message-id: <1398864419.14545.8.camel@AMDC1943>
Subject: Idea: regulator: Merge s2mpa01 with s2mps11
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Mark Brown <broonie@linaro.org>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 15:26:59 +0200
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4VV2pXwnBBn8Wa1psun6d1eLyrjls
	FlcunWKzuLjiC5MDi8eda3vYPPq2rGL0+LxJLoA5issmJTUnsyy1SN8ugSvj0KMVjAVnmCtO
	dS5nb2B8xdTFyMEhIWAi8fRFeRcjJ5ApJnHh3nq2LkYuDiGBpYwS20+/ZYdwPjNK/G1uZQWp
	4hXQl3h16i8biC0M1Dzv7wUwm03AWGLz8iVgtoiAtsT89suMIDazQLrEp9dfWUBsFgFVid+N
	86Di6hKT5i1ihtisLDFv/zEmiPmCEj8m32OBqJGX2LzmLfMERr5ZSFpmISmbhaRsASPzKkbR
	1NLkguKk9FxDveLE3OLSvHS95PzcTYyQEPyyg3HxMatDjAIcjEo8vAJb44OFWBPLiitzDzFK
	cDArifDy3U8IFuJNSaysSi3Kjy8qzUktPsTIxMEp1cDYeNFjAb9pbHLIFqO9n3LPTjp548T1
	FZ2tm6YaWszRUwza9zFNxIvh2rENn/dVPJjX5MNt3bv7Qe0l4dTbbFfZsgwFVCyV/Ssy67y2
	xD5Pj/tdr9kwRUH+f6bVCl5vg8W3mEJDnngV/WXYarZl9ukT3xY57ZnUFb6kYGXU03kLVrBL
	iqZOiH6sxFKckWioxVxUnAgAf5LYDR8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Sachin,


The S2MPA01 and S2MPS1X PMICs regulator drivers look quite similar to
each other. Most of the S2MPA01 driver is the same as S2MPS11 (except
changes added for supporting S2MPS14).

I would like to merge these drivers into one. However I do not have
neither any board with S2MPA01 nor S2MPA01 datasheet.

What do you think about merging them? Could you test it later when I
will finish the development?


Best regards,
Krzysztof

