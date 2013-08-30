Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3H3MCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:02:17 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34607 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3H3MCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:02:14 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-64-522089c4de4b
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: m.chehab@samsung.com
Cc: kyungmin.park@samsung.com, t.stanislaws@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v4 0/2] media: s5p-tv: clean-up and fixes
Date: Fri, 30 Aug 2013 14:01:59 +0200
Message-id: <1377864121-19587-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t9jAd0jnQpBBtf2mFmcbXrDbrHp8TVW
	i8u75rBZ9GzYympxcZ28xek1p5gt5rW/ZHVg99i8pN7j4Ls9TB59W1YxenzeJBfAEsVlk5Ka
	k1mWWqRvl8CV0TZhMWPBLraKS6d3sTYwTmXtYuTkkBAwkVg+ay87hC0mceHeerYuRi4OIYFF
	jBInr99nAkkICbQzSZxucQex2QTMJSY+28QCYosISEjcX/2MDcRmFjjPKHHuUnwXIweHsICl
	xNVtYSBhFgFVicafH8Hm8wr4Sfz/vYcFYpeCxM/LJ9gmMHIvYGRYxSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREcFM+kdzCuarA4xCjAwajEw9swVT5IiDWxrLgy9xCjBAezkghvRapCkBBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZJg5OqQbGyDsPmneLWZns
	Kkj6teNwl1J4S/rzT20b+lskBQ6cYa9q9W6VSOGrzt17mKd/1Zf9ik6sy5b+MXNm+qZ89ZjP
	p9/Lapp+RTIVeyxuL2O/+aaiS7Lzy5Vn/mln373ynf7GvpQhjdFfJcQt77qL6d/qb0cb/pie
	320s5nw17mt8dsacCcJfJkcqsRRnJBpqMRcVJwIAC/Q/WAYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add restoring previous vpll rate after driver offs stream 
or recives error.
It also replace mxr_info, mxr_dbg, mxr_warn and mxr_err macro 
by generic solution.

Mateusz Krawczuk (2):
  media: s5p-tv: Replace mxr_ macro by default dev_
  media: s5p-tv: Restore vpll clock rate

 drivers/media/platform/s5p-tv/mixer.h           |  12 ---
 drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
 drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
 drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
 drivers/media/platform/s5p-tv/mixer_video.c     | 100 ++++++++++++------------
 drivers/media/platform/s5p-tv/mixer_vp_layer.c  |   2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c         |  25 +++++-
 7 files changed, 101 insertions(+), 93 deletions(-)

-- 
1.8.1.2

