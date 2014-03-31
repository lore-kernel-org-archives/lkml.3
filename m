Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaCaUz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:55:58 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:50579 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaCaUzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:55:50 -0400
Message-ID: <5339D650.2060203@gmail.com>
Date: Mon, 31 Mar 2014 22:55:44 +0200
From: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/2] staging: comedi: drivers.c: Fix missing a blank line,
 after declarations warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yves Deweerdt <yves.deweerdt.linux@gmail.com>
---
 drivers/staging/comedi/drivers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index ab0e8ed..cb5d214 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -258,6 +258,7 @@ static int insn_rw_emulate_bits(struct comedi_device *dev,
 	const unsigned base_bitfield_channel =
 	    (chan < channels_per_bitfield) ? 0 : chan;
 	unsigned int new_data[2];
+
 	memset(new_data, 0, sizeof(new_data));
 	memset(&new_insn, 0, sizeof(new_insn));
 	new_insn.insn = INSN_BITS;
-- 
1.8.3.2

