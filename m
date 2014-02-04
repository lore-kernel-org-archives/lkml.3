Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaBDJ56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:57:58 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43544 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaBDJ5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:57:51 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-19-52f0b99dcaad
From: Amit Grover <amit.grover@samsung.com>
To: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kyungmin.park@samsung.com, k.debski@samsung.com,
        prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
        hans.verkuil@cisco.com, hverkuil@xs4all.nl, swaminath.p@samsung.com
Cc: jtp.park@samsung.com, Rrob@landley.net, andrew.smirnov@gmail.com,
        anatol.pomozov@gmail.com, jmccrohan@gmail.com, joe@perches.com,
        awalls@md.metrocast.net, arun.kk@samsung.com, amit.grover@samsung.com,
        austin.lobo@samsung.com
Subject: [PATCH v3 0/2] drivers/media: Add controls for Horizontal and Vertical
 MV Search Range
Date: Tue, 04 Feb 2014 15:29:57 +0530
Message-id: <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <52E0ED10.2020901@samsung.com>
References: <52E0ED10.2020901@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWyRsSkVnfuzg9BBlt2C1o86/vEavGyt9Ci
	ucPW4uOp26wW8z/dZLF4055kseTnLiaLU5OfMVn0P1rPaDH7/mMWiyNrrzJZ/Hh9gc3ibNMb
	dotNj6+xWixsW8JicXnXHDaLng1bgYbdX8Fs8fTVczaLw2/aWS3auqYyOoh6TPm9kdVj56y7
	7B6vVs9k9di8pN5j1oXN7B5fVl1j9ujbsorR4/MmOY9TXz+zB3BGcdmkpOZklqUW6dslcGVM
	vXWFvaCHs+LL+pvsDYyr2bsYOTkkBEwkbpzdwAphi0lcuLeerYuRi0NIYCmjxJYvU5lhih6s
	+c0IkZjOKHHi12WwhJBAD5PEup3yIDabgLbE9hnLwbpFBDYwSTzsvsgO4jALvGKUODZ5BViH
	sECixKuXt5lAbBYBVYnG1oNgu3kF3CV+P3rH0sXIAbROQWLOJBuQMCfQ0M1rOpgglmlJ3L97
	lBlkpoTAXA6Jpwt62CDmCEh8m3wIqldWYtMBqKslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJD
	veLE3OLSvHS95PzcTYzAqDz971nvDsbbB6wPMSYDjZvILCWanA+M6rySeENjMyMLUxNTYyNz
	SzPShJXEeZMeJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYMy8GaOV98+5af5XSy6BrHv6
	hb4qck4+Z1qOSdUV9R90XTpVdtmUnZFzIhSLE9XnK1tuTiz4HbdIPYF7j922dJtlT8VZwk4G
	tDQ3ZEy7J5dyift0/ekNSQG7n887E3UiNUvplEy+xIPe5bvjOL+/+GjJUfFv38/WqmiHmPKL
	D10lPI/P+JIrr8RSnJFoqMVcVJwIADjjZNPgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd25Oz8EGfR3s1k86/vEavGyt9Ci
	ucPW4uOp26wW8z/dZLF4055kseTnLiaLU5OfMVn0P1rPaDH7/mMWiyNrrzJZ/Hh9gc3ibNMb
	dotNj6+xWixsW8JicXnXHDaLng1bgYbdX8Fs8fTVczaLw2/aWS3auqYyOoh6TPm9kdVj56y7
	7B6vVs9k9di8pN5j1oXN7B5fVl1j9ujbsorR4/MmOY9TXz+zB3BGNTDaZKQmpqQWKaTmJeen
	ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9p6RQlphTChQKSCwuVtK3wzQh
	NMRN1wKmMULXNyQIrsfIAA0krGHMmHrrCntBD2fFl/U32RsYV7N3MXJySAiYSDxY85sRwhaT
	uHBvPVsXIxeHkMB0RokTvy4zgySEBHqYJNbtlAex2QS0JbbPWA5WJCKwgUniYfdFdhCHWeAV
	o8SxySvAOoQFEiVevbzNBGKzCKhKNLYeZAWxeQXcJX4/esfSxcgBtE5BYs4kG5AwJ9DQzWs6
	mCCWaUncv3uUeQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwTH/THoH46oGi0OM
	AhyMSjy8CiofgoRYE8uKK3MPMUpwMCuJ8JpvAwrxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhy
	PjAd5ZXEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY9/nLGHj
	CzuSWDrNRVwWXb4kxGw5lcFsoe+Pj76heQLZEwUsA0+8s3ni8m5dWoRgb9eKZbe701asrc9a
	vUjWx+e5mY3stAV+N10CDbNEu3fbZvp6TP9gX7Fn69Q970/y7nZW/Wao1FyX0F4w52X7jLBn
	6nmW4u2521T84nKDJQLOaNQ0z52oxFKckWioxVxUnAgAJx/ZST0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 version for the patch:
s5p-mfc: Add Horizontal and Vertical search range for Video Macro Blocks
(https://lkml.org/lkml/2013/12/30/83)

Changes from v1:
1) Splitted the patch into V4L2 and MFC driver patches.
2) Incorporated review comments on v1.

Changes from v2:
1) Removed the range restrictions from drivers/media/v4l2-core/v4l2-ctrls.c.
2) Rebased the patch to git://linuxtv.org/mchehab/media-next.git.
3) Added [media] tag in title.

Amit Grover (2):
  [media] v4l2: Add settings for Horizontal and Vertical MV Search
    Range
  [media] s5p-mfc: Add Horizontal and Vertical MV Search Range

 Documentation/DocBook/media/v4l/controls.xml    |   20 +++++++++++++++++++
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 drivers/media/v4l2-core/v4l2-ctrls.c            |    6 ++++++
 include/uapi/linux/v4l2-controls.h              |    2 ++
 7 files changed, 57 insertions(+), 6 deletions(-)

-- 
1.7.9.5

