Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab3JaMCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:02:45 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:38874 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038Ab3JaMCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:02:44 -0400
From: <srinivas.kandagatla@st.com>
To: <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@kernel.org>, <srinivas.kandagatla@st.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH RFC 0/2] Introduce BITS_MASK macro
Date: Thu, 31 Oct 2013 11:53:09 +0000
Message-ID: <1383220389-18420-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch series introduces BITS_MASK macro which creates a mask for a given
lsb and msb bit locations. The usage of masks spread over mutiple bits is
becoming very common for example with regmap_update_bits kind of apis. Having a
common macro for this makes much sense and is clean and readable way to encode
the mask rather than having an hex number for a mask.

Second patch is to show an example usage of this new macro in regmap.

Comments ?

Thanks,
srini

Srinivas Kandagatla (2):
  bitops: introduce BITS_MASK macro
  regmap: move to using BITS_MASK macro

 drivers/base/regmap/regmap.c |    3 +--
 include/linux/bitops.h       |    1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.6.5

