Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3AOIzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 03:55:35 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52157 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756501Ab3AOIze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 03:55:34 -0500
MIME-Version: 1.0
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 15 Jan 2013 14:25:12 +0530
Message-ID: <CA+V-a8sVhQDoni=mouiOjNCmgfn_rJTHaNfQ-O_E0yxMkeRfRA@mail.gmail.com>
Subject: [GIT PULL FOR v3.9] media i2c devices trivial fixes
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please pull the following patches, which use devm_kzalloc() instead of
kzalloc().

Regards,
--Prabhakar Lad

The following changes since commit 3151d14aa6e983aa36d51a80d0477859f9ba12af:

  [media] media: remove __dev* annotations (2013-01-11 13:03:24 -0200)

are available in the git repository at:
  git://linuxtv.org/mhadli/v4l-dvb-davinci_devices.git media-i2c-fixes

Lad, Prabhakar (4):
      ths7303: use devm_kzalloc() instead of kzalloc()
      tvp7002: use devm_kzalloc() instead of kzalloc()
      tvp514x: use devm_kzalloc() instead of kzalloc()
      adv7343: use devm_kzalloc() instead of kzalloc()

 drivers/media/i2c/adv7343.c |    9 +++------
 drivers/media/i2c/ths7303.c |    3 +--
 drivers/media/i2c/tvp514x.c |    4 +---
 drivers/media/i2c/tvp7002.c |   18 ++++++------------
 4 files changed, 11 insertions(+), 23 deletions(-)
