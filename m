Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaB1VXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:23:10 -0500
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:59441
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752450AbaB1VXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:23:07 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [PATCH 0/3] media/drx39xyj: fix DJH_DEBUG path null pointer dereferences, and compile errors.
Date: Fri, 28 Feb 2014 14:22:59 -0700
Message-Id: <cover.1393621530.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes null pointer dereference boot failure as well as
compile errors.

Shuah Khan (3):
  media/drx39xyj: fix pr_dbg undefined compile errors when DJH_DEBUG is
    defined
  media/drx39xyj: remove return that prevents DJH_DEBUG code to run
  media/drx39xyj: fix boot failure due to null pointer dereference

 drivers/media/dvb-frontends/drx39xyj/drxj.c | 31 ++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 12 deletions(-)

-- 
1.8.3.2

