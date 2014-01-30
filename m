Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaA3Fkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 00:40:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41502 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaA3Fkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 00:40:35 -0500
X-AuditID: cbfee68e-b7f566d000002344-88-52e9e5d1cecf
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
Subject: [PATCH v2 0/2] drivers/media: Add controls for Horizontal and Vertical
 MV Search Range
Date: Thu, 30 Jan 2014 11:12:41 +0530
Message-id: <1391060563-27015-1-git-send-email-amit.grover@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <52E0ED10.2020901@samsung.com>
References: <52E0ED10.2020901@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWyRsSkRvfi05dBBh/Pmlk86/vEavGyt9Ci
	ucPW4uOp26wW8z/dZLF4055kseTnLiaLU5OfMVn0P1rPaDH7/mMWiyNrrzJZ/Hh9gc3ibNMb
	dotNj6+xWixsW8JicXnXHDaLng1bgYbdX8Fs8fTVczaLw2/aWS3auqYyOoh6TPm9kdVj56y7
	7B6vVs9k9di8pN5j1oXN7B5fVl1j9ujbsorR4/MmOY9TXz+zB3BGcdmkpOZklqUW6dslcGVM
	mLWTvaCFo6JxxQ7GBsadbF2MnBwSAiYSDSevs0DYYhIX7q0HinNxCAksZZS49G0lM0zRi6n7
	WCESixglDj4+zAzh9DBJPHm1CmwUm4C2xPYZy8HaRQQ2MEk87L7IDuIwC7xilDg2eQXYLGGB
	RImmhh1gHSwCqhKnznUzgti8Au4S729eALI5gPYpSMyZZAMS5gQaunlNBxOILSSgJXH/7lGw
	zRICMzkkzs/cwA4xR0Di2+RDLBC9shKbDkCdLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525iBMbl6X/P+nYw3jxgfYgxGWjcRGYp0eR8YFznlcQbGpsZWZiamBobmVua
	kSasJM676GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG3m2Hb1a8mH48UrVV7/rDORv4
	/QxPTGWMF/L5q7vv1OY+21cnFydzrruTsqH14mwXtdrI/61l1hWuexk32T0/dHzlnSVaU5fN
	0mc+etV7oiuP5eelIX9NLrVnrV9yPbSS+eimELNFYe+2yIkHSgu6/t2/oT6PqXkz+6n+RtHK
	xUInalea/Ox6qcRSnJFoqMVcVJwIALYV5zLhAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd2LT18GGUxr0rF41veJ1eJlb6FF
	c4etxcdTt1kt5n+6yWLxpj3JYsnPXUwWpyY/Y7Lof7Se0WL2/ccsFkfWXmWy+PH6ApvF2aY3
	7BabHl9jtVjYtoTF4vKuOWwWPRu2Ag27v4LZ4umr52wWh9+0s1q0dU1ldBD1mPJ7I6vHzll3
	2T1erZ7J6rF5Sb3HrAub2T2+rLrG7NG3ZRWjx+dNch6nvn5mD+CMamC0yUhNTEktUkjNS85P
	ycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAH6TkmhLDGnFCgUkFhcrKRvh2lC
	aIibrgVMY4Sub0gQXI+RARpIWMOYMWHWTvaCFo6KxhU7GBsYd7J1MXJySAiYSLyYuo8VwhaT
	uHBvPVCci0NIYBGjxMHHh5khnB4miSevVoF1sAloS2yfsRysSkRgA5PEw+6L7CAOs8ArRolj
	k1cwg1QJCyRKNDXsAOtgEVCVOHWumxHE5hVwl3h/8wKQzQG0T0FiziQbkDAn0NDNazqYQGwh
	AS2J+3ePMk9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjqn0nvYFzVYHGIUYCD
	UYmHd8Xkl0FCrIllxZW5hxglOJiVRHjj7gKFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0OR+Y
	kPJK4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgXGR0GwHRa6c
	l98EpD4uKGZ/oNB3UdToY0b37Tjp2y3TzzhW8JzWrlXf6/m/Ja6uYQabxNXpgrldnaw3nrjJ
	T+XZ2fuV6+r6TSu49V4ucNG+l9c6uf1EFGthWimzstbVbT2VDjtecB8I/3FqzqLJad9e7ojw
	culMf+hy2EBxw6megAdajd9kWpVYijMSDbWYi4oTASUnj1o+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'master' branch of Linux-next.
This is v2 version for the patch:
s5p-mfc: Add Horizontal and Vertical search range for Video Macro Blocks
(https://lkml.org/lkml/2013/12/30/83)

Changes from v1:
1) Splitted the patch into v4l2 and mfc driver patches.
2) Incorporated review comments of v1

Amit Grover (2):
  drivers/media: v4l2: Add settings for Horizontal and Vertical MV
    Search Range
  drivers/media: s5p-mfc: Add Horizontal and Vertical MV Search Range

 Documentation/DocBook/media/v4l/controls.xml    |   20 +++++++++++++++++++
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 drivers/media/v4l2-core/v4l2-ctrls.c            |   14 +++++++++++++
 include/uapi/linux/v4l2-controls.h              |    2 ++
 7 files changed, 65 insertions(+), 6 deletions(-)

-- 
1.7.9.5

