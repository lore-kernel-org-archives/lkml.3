Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab3IKCVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:21:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36863 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IKCVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:21:22 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-7b-522fd3a03d45
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 0/3] extcon: use dev_get_platdata()
Date: Wed, 11 Sep 2013 11:21:20 +0900
Message-id: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ulZa6uUhwZIzATbuZxRtBD2SFVw==
Content-language: ko
x-cr-hashedpuzzle: Aw8H Cpku FGvC GJAY HjXr HvNC H+m5 MNC9 Stx3 TrEl azSo gH4z
 gIoK mrxF nb3c
 n990;4;YwB3ADAAMAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AeQB1AG4AZwBqAG8AbwAuAGgAYQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{48FA155A-7AA8-43E9-ABB9-E16D34E0194E};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 11 Sep 2013 02:21:14
 GMT;WwBQAEEAVABDAEgAIAAwAC8AMwBdACAAZQB4AHQAYwBvAG4AOgAgAHUAcwBlACAAZABlAHYAXwBnAGUAdABfAHAAbABhAHQAZABhAHQAYQAoACkA
x-cr-puzzleid: {48FA155A-7AA8-43E9-ABB9-E16D34E0194E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zfd0Fl/WDDPrWa1lc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2N+x0bGghbmiobG22wNjJuZ
	uhg5OSQETCSu/ZnKAmGLSVy4t56ti5GLQ0hgGaPE9gnLmGGKrm87BNYgJLCIUWLiDy6Iol+M
	Eqt/XwbrZhNQk/jy5TA7iC0ioCUxsXMmWAOzQKHE7RtzWUFsYQFjiVN7r4HZLAKqEr8OLAOz
	eQVsJd4u3AhlC0r8mHyPBaJXS2L9zuNQc+QlNq95C3QQB9BB6hKP/upCrNKTuLN6JjNEiYjE
	vhfvGCFufsIicXFCPYRtKjGhbR0LyM0SAtvYJboO/WCDuEFA4tvkQywQM2UlNh2A+ldS4uCK
	GywTGCVmIbloFpKLZiG5aBaS1QsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihETghB2M
	9w5YH2JMBlo/kVlKNDkfGMF5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQW
	xReV5qQWH2Jk4uCUamCcpXtrTqGwcLzm/XtBp75yBk75x6r8yL5zcbeTCNMRvgi1TwvntbYa
	ij5wV9rom8kyz1K0UP5U7wPvZYl+Rr6xryTMjkz4xRLv3PyMyX/DlR1eIq6vpk0tXKaisjJ7
	+uyVJ1v+6G8/E83O91bh8YRHPa8r4iwTt7vmLbnk7Xtb9F4399r/GzYrsRRnJBpqMRcVJwIA
	hVObotYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jAd0Fl/WDDHZcUrO4/uU5q8XlhZeA
	xK45bBa3G1ewObB49G1ZxejxeZNcAFNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
	oaWFuZJCXmJuqq2Si0+ArltmDtAmJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhHWPG/I6NjAUtzBUNjbfZGhg3M3UxcnJICJhIXN92CMoWk7hwbz0biC0ksIhRYuIPri5G
	LiD7F6PE6t+XWUASbAJqEl++HGYHsUUEtCQmds4Ea2YWKJS4fWMuK4gtLGAscWrvNTCbRUBV
	4teBZWA2r4CtxNuFG6FsQYkfk++xQPRqSazfeRxqjrzE5jVvmbsYOYAOUpd49FcXYpWexJ3V
	M5khSkQk9r14xwhx8xMWiYsT6iFsU4kJbetYJjAKzUKyYRaSDbOQbJiFZNQCRpZVjKKpBckF
	xUnpuYZ6xYm5xaV56XrJ+bmbGMHx/UxqB+PKBotDjAIcjEo8vDfk9IOEWBPLiitzDzFKcDAr
	ifBOdQIK8aYkVlalFuXHF5XmpBYfYkwGBsBEZinR5Hxg6skriTc0NjEzsjQyszAyMTcnTVhJ
	nPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbTcI8ZZ0/YHT24i0fa4P7z2xNa1rsGrL719gbH
	NY/mgub8++q31VaumH9BpETUpuOd7usr744ElW70OyyvvfDKhu6ZjC6F3e7bje+2tqQdPPR6
	u5D/kxDdrcFXcueIpTu9vVrEYZm/fPayc+fsXYyVZY4t2G2X/GqCwbzZrxTnrpW7tjPB9+AZ
	JZbijERDLeai4kQAhIEQ2DMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

---
 drivers/extcon/extcon-adc-jack.c |    2 +-
 drivers/extcon/extcon-gpio.c     |    2 +-
 drivers/extcon/extcon-palmas.c   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


