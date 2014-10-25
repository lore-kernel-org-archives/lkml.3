Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaJYUVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:21:20 -0400
Received: from mail-vc0-f193.google.com ([209.85.220.193]:51210 "EHLO
	mail-vc0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJYUVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:21:19 -0400
MIME-Version: 1.0
Date: Sun, 26 Oct 2014 04:21:18 +0800
Message-ID: <CANHbGWtbjgLGmy_CxBJ43XVfq6zaaqFvmWWCAXe7NEidO9_fFQ@mail.gmail.com>
Subject: Does spi-gpio and bitband support 3-wire Bidirectional most/miso
 share pin usage?
From: V JobNickname <workofv@gmail.com>
To: linux-spi@vegr.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a device use 3-wire spi which are CS,SCK,and a DATA for
read/write.( maybe a.s.k.a SISO)
The command format like as p.18 in
www .newhavendisplay .com/app_notes/NV3035C.pdf

The spi-gpio can't register miso and mosi for same GPIO pin.
Also I traced SPI-3WIRE flag it seems only support half 3-wire which
only write or only read but share ping

Does current driver can support this kind of 3wire spi format? Or I
need to do some modify to support this 3-wire spi
