Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbaGCMhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 08:37:36 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50686 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaGCMhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 08:37:35 -0400
MIME-Version: 1.0
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Thu, 3 Jul 2014 14:37:18 +0200
Message-ID: <CAL8zT=gW-OCeeOhKZzqgVSxDE5gsWt2O9nQ9mt7diDZQvvRO=w@mail.gmail.com>
Subject: Lattice ECP3 FPGA with i.MX6
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: sr@denx.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a board, with a Freescale i.MX6 chip and a ECP3-35 FPGA on SPI.
I tried to load the firmware using the lattice-ecp3-config driver, but
it fails with this error :

lattice-ecp3 spi32766.3: FPGA bitstream configuration driver registered
lattice-ecp3 spi32766.3: Error: No supported FPGA detected (JEDEC_ID=808004c2)!

In the driver, the id is :

#define ID_ECP3_35 0xc2048080

Obviously, there is a big/little endian issue... Do I need to instruct
the device-tree in a specific way in order to get the bus in the
correct order ? Or is this a known issue maybe ?

Thanks,
JM
