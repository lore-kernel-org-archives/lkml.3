Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaCJJzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:55:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45336 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCJJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:55:36 -0400
X-AuditID: cbfee68e-b7f566d000002344-d3-531d8c174769
Date: Mon, 10 Mar 2014 09:55:35 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 3/3] regulator: max8998: Remove unnecessary **rdev from
 struct max8998_data
To: Axel Lin <axel.lin@ingics.com>, Mark Brown <broonie@kernel.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140310095427335@myungjoo.ham
Msgkey: 20140310095427335@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140310095427335@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <3908098.448981394445332812.JavaMail.weblogic@epv6ml07>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSrCveIxts0HWHy+LyrjlsDowenzfJ
	BTBGcdmkpOZklqUW6dslcGUcWv+IqWALc8Xn08fYGhiXMHcxcnIICahLLFpykq2LkYNDQsBE
	4mUHC0hYQkBM4sK99WwQJUsZJdY8doWIm0gcX9gP1MoFFJ/PKLGk8QcjSIJFQFVi+63P7CBz
	2AT0JGZ+TgYJCwvES/Qtvge2SkTAU6Lh+AlGkF5mgUuMEh83/IBaoCSxZt8rsMW8AoISJ2c+
	gTpCVWJ+/wo2iLiaxJq5f9kg4hISs6ZfYIWweSVmtD+FqpeTmPZ1DTOELS1xftYGRphnFn9/
	DBXnlzh2ewcTxL+8Ek/uB8OM2b35C9R4AYmpZw5CtWpJ7G0+DbWKT2LNwrcsMGN2nVrODNN7
	f8tcJhCbWUBRYkr3Q3YIW0viy499bOje4hVwlph1dz3rBEblWUhSs5C0z0LSjqxmASPLKkbR
	1ILkguKk9CIjveLE3OLSvHS95PzcTYzApHD637O+HYw3D1gfYkwGRslEZinR5HxgUskriTc0
	NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwRLJ9kQ3c+
	i7nkFx/EJ6IgHDjhvUWSd9K7hw6MAnOd5k+5FrWh+EW1wZ8rnwUOyvTM9p8XUCCl2TZxQcyL
	1TX6l9UM3uWEPy9mfPJ194vHMz5viVA4w3jrxIKpEue2XzzAtetx/cytV16/yb1xWO3zn8vX
	l/fsKNH5wd/rkFrQNO3dsiXXZ2kvVGIpzkg01GIuKk4EACJDALsgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dF3xHtlggynrWCwu75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWsah
	9Y+YCrYwV3w+fYytgXEJcxcjJ4eQgLrEoiUn2UBsCQETieML+5khbDGJC/fWA8W5gGrmM0os
	afzBCJJgEVCV2H7rM3sXIwcHm4CexMzPySBhYYF4ib7F98B6RQQ8JRqOn2AE6WUWuMQo8XHD
	DzaIZUoSa/a9YgGxeQUEJU7OfMICsUxVYn7/CjaIuJrEmrl/oQ6SkJg1/QIrhM0rMaP9KVS9
	nMS0r2ugDpWWOD9rAyPM0Yu/P4aK80scu72DCeROkN4n94Nhxuze/AVqvIDE1DMHoVq1JPY2
	n4ZaxSexZuFbFpgxu04tZ4bpvb9lLhOIzSygKDGl+yE7hK0l8eXHPjZ0b/EKOEvMuruedQKj
	3CwkqVlI2mchaUdWs4CRZRWjaGpBckFxUnqFoV5xYm5xaV66XnJ+7iZGcHp6tnAH45fz1ocY
	BTgYlXh4F6bLBguxJpYVV+YeYpTgYFYS4X3YChTiTUmsrEotyo8vKs1JLT7EmAyMwInMUqLJ
	+cDUmVcSb2hsbGJmYmppYmFgak6asJI4792bSUFCAumJJanZqakFqUUwW5g4OKUaGNnUZuqG
	xu7ynWzGKHXhUbNrVWDl3KezDCfeKKxhmJFff89mV0bQ/4R1LduVcxhP7vE12Hmxfmbz7qOH
	pW9miW19w/DLqf+Q//UNykHKnZVfw/iMbBquFbz9XrHmF+/8bKZcvnenryzjs+F2FJnsU7/f
	7bTPt1W7fr0+Fxwz2es/n36dcfGNXCWW4oxEQy3mouJEANNtkfyTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2A9tg84015759

> Now we are using devm_regulator_register(), so we don't need to allocate *rdev[]
> array to store return value of devm_regulator_register. Use a *rdev variable is
> enough for checking return status.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
