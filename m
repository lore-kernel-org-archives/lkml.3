Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965648AbaCUCe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:34:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60390 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbaCUCeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:34:24 -0400
X-AuditID: cbfee68f-b7f156d00000276c-69-532ba52f0ed9
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        myungjoo.ham@gmail.com
Subject: [PULL REQUEST for Rafael] PM / devfreq: pull request
Date: Fri, 21 Mar 2014 11:34:49 +0900
Message-id: <1395369289-6416-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.8.3.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWyRsSkWFd/qXawwcGznBaXd81hs/jce4TR
	4vmmTlaLM6cvsTqweOycdZfdY8vVdhaPz5vkApijuGxSUnMyy1KL9O0SuDLO/JrHWHCDv2Lh
	N94Gxo+8XYycHBICJhLn/q1hgrDFJC7cW8/WxcjFISSwlFGi+8EXNpiitQ0fmSESixglXt64
	xgLhtDFJNE/4xQpSxSagK7F1w10WEFtEQFTi8u4JYDazQIjEkh1HGEFsYQFbie7Zp9m7GDk4
	WARUJd6dygYxeQXcJf6c9YTYpSCx7MtasF0SArfZJLa8PcEOkmAREJD4NvkQC0i9hICsxKYD
	zBD1khIHV9xgmcAouICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYACe/vesfwfj3QPW
	hxiTgcZNZJYSTc4HBnBeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamBccrDP8ePa2t1r/z3xt33yKSvv2/rWTReC377T2TklornzRiXjgw2Zq83s
	2u4ZKh3fto+7U7p+emG0YW1Welvqgfr/e9ut90Z83X/zFvuXjXb+VUxFojMV5P+29c0VWcH+
	3E+PPc7vjtrLmffnRslHPCl/f/GpbF156Sa5Rr5XrSWaLzd1b/qrxFKckWioxVxUnAgAhLcQ
	zlYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jAV39pdrBBq2PmCwu75rDZvG59wij
	xfNNnawWZ05fYnVg8dg56y67x5ar7SwenzfJBTBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7
	x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHr
	GxIE12NkgAYS1jBmnPk1j7HgBn/Fwm+8DYwfebsYOTkkBEwk1jZ8ZIawxSQu3FvP1sXIxSEk
	sIhR4uWNaywQThuTRPOEX6wgVWwCuhJbN9xlAbFFBEQlLu+eAGYzC4RILNlxhBHEFhawleie
	fZq9i5GDg0VAVeLdqWwQk1fAXeLPWU+IXQoSy76sZZ7AyL2AkWEVo2hqQXJBcVJ6rqFecWJu
	cWleul5yfu4mRnB4P5PawbiyweIQowAHoxIPbwWndrAQa2JZcWXuIUYJDmYlEd7X3UAh3pTE
	yqrUovz4otKc1OJDjMlAuycyS4km5wNjL68k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGNkP2bMdK9gYyeUivCdwftWn1+VscxdHTXwbXFyt9qZHx33BvrBy
	nVOix5n/bN+1dLPOw/+F6/d2BjgyzJr4+Djb8azDKhpPwt50pix8v/ey3FGF9quSy/o+Z8sk
	dblYXPN8u9GL68qBsJIr/G+qzMxtxFcfrK40Z4k5xGRpdTyJ87P3EfGeHiWW4oxEQy3mouJE
	AAsUmnezAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Dear Rafael,


Here goes bugfix devfreq patch.

Recent patchset of device-tree support / exynos driver updates is omitted in this pull request
as there could be further updates on the patchset.


Cheers,
MyungJoo


The following changes since commit dcb99fd9b08cfe1afe426af4d8d3cbc429190f15:

  Linux 3.14-rc7 (2014-03-16 18:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git for-rafael

for you to fetch changes up to e35d35a1c0b3a7317d77e03e686a4a205cdd4eed:

  PM / devfreq: Rewrite devfreq_update_status() to fix multiple bugs (2014-03-21 11:16:30 +0900)

- ----------------------------------------------------------------
Pull request for Rafael. Bugfix only.
(recence changes of DT/Exynos drivers need further work)

- ----------------------------------------------------------------
Saravana Kannan (1):
      PM / devfreq: Rewrite devfreq_update_status() to fix multiple bugs

 drivers/devfreq/devfreq.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTK6S5AAoJEBOhurvWBoCKuoQQAJjAVcoCzlrjUSSr8y++mXfU
UIJCrJrJR7jFIBc2ykACYXG9zrHg0/OL3VgJHd8Yj9NWtRCNv6shOZ7vk2XZ7M2r
19Lf3+wDR3zBKvCCKoSoh+crywIgXHhpI8Bgxi+rAZmxkDdv/vlFZAlPWt0pxjQG
M19zb0Y+VDgWinfwrR0kP5sPCGSoUQVU085h4Kf+OjeB2ZMWDeR/49fAlSVPFFi6
XDU68mhwytmUdLpqOv/q5c0sNEBgaj00oKyAkco5eccQ8g3+ZwFWdxzLwCoARW/N
beXz/Tr6fc/7x9l1xSdBcuxmH8Lv6OxXUMrewGx2nIyBxgDzHCQ4tKbi1URWuzyy
4LnTqNZbsgQi3EzeNdb5CqFqCIhR63uGfBtyLUTWi9QPgj4CBffgAigcXLZVkL6e
/dpiRHEQGjijRuJxVqdx8WqR0ucMOYHa890Du6l50LlI9uoiyr8I24/+qVPTZBmN
CgSloQe748k2+IXckjNa4TivEDqMCMtn1YPQu23OODg2b98n+gDnwYQFsvi52WH+
Ue5Uidv14o0M/rCYDCkBHdv+Xh+VIRdAhrX/OeAv5xxi996JG8gJW5uXBWX4BdWu
6BugMPW0dmIUnfTTUfeekfLYA+VdN44Rv2L0CdgeMr29qvkT991GBEs6w1wkyI6Z
CpjCdg3UclJ78WVIr+KJ
=CYyn
-----END PGP SIGNATURE-----
