Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759386Ab3LGAYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:24:14 -0500
Received: from top.free-electrons.com ([176.31.233.9]:56231 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753840Ab3LGAYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:24:12 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: lars@metafoo.de, Marek Vasut <marex@denx.de>, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv4 0/3] iio: mxs-lradc: add support to optional divider_by_two
Date: Sat,  7 Dec 2013 01:23:57 +0100
Message-Id: <1386375840-24984-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is v4 of the patchset that adds support to the optional divider_by_two of
LRADC channels.

Changes since v3:
 - removed DT bindings for vref_mv (was the second patch of the series)
 - rebased on v3.13.0-rc3
 - the first patch of the previous series had been applied previously
 - this will apply after https://lkml.org/lkml/2013/12/6/676

This was tested on a custom i.MX28 platform.
Could someone please test on an i.MX23?

Hector Palacios (3):
  iio: mxs-lradc: add scale attribute to channels
  iio: mxs-lradc: add scale_available file to channels
  iio: mxs-lradc: add write_raw function to modify scale

 drivers/staging/iio/adc/mxs-lradc.c | 222 +++++++++++++++++++++++++++++++++++-
 1 file changed, 219 insertions(+), 3 deletions(-)

-- 
1.8.3.2

