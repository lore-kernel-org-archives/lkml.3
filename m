Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762408Ab3DCRDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:03:22 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:61699 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3DCRDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:03:21 -0400
MIME-Version: 1.0
Date: Wed, 3 Apr 2013 20:03:19 +0300
Message-ID: <CALG_nUF6EB8_Z6JTW-ohYmc_qY020N+87tcNC9sDMiyMSwtFOA@mail.gmail.com>
Subject: NVIDIA RAID don't work with kernel 3.8
From: =?UTF-8?B?0JjQu9GM0Y8=?= <13ilya@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a motherboard ASUS M2N32-SLI DELUXE with chipset NVIDIA nForce
® 590 SLI ™ MCP (defined as the MCP55) with built-in hardware RAID
which I have configured as a RAID 0 of 4-HDD

When using kernel 3.8 in the openSUSE repository
http://download.opensuse.org/repositories/Kernel:/stable/standard/x86_64/kernel-vanilla-3.8.5-1.1.x86_64.rpm
I no longer identificate raid with a message at boot

ERROR: nvidia: wrong # of devices in RAID set "nvidia_ieigdchd" [1/4]
on /dev/sda
ERROR: removing inconsistent RAID set "nvidia_ieigdchd"
ERROR: no RAID set found

In this case, the base kernel 3.7.10 works fine.

Is maybe it some kind of boot options, or editing boot scripts to
solve the problem?
