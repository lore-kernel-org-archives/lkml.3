Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbaDIPSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:18:01 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51250 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbaDIPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:17:57 -0400
Subject: [PATCH 0/2] Updates to fence api
To: linux-kernel@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, ccross@google.com,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        dri-devel@lists.freedesktop.org, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Wed, 09 Apr 2014 16:48:13 +0200
Message-ID: <20140409144239.26648.57918.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements small updates to the fence api.
I've found them useful when implementing the fence API in ttm and i915.

The last patch enables RCU on top of the api. I've found this less
useful, but it was the condition on which Thomas Hellstrom was ok
with converting TTM to fence, so I had to keep it in.

If nobody objects I'll probably merge that patch through drm, because
some care is needed in ttm before it can flip the switch on rcu.

---

Maarten Lankhorst (2):
      reservation: update api and add some helpers
      [RFC] reservation: add suppport for read-only access using rcu

