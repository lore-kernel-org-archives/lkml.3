Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab3DNGf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 02:35:29 -0400
Received: from mail1-ar.fullrate.dk ([90.185.0.67]:53787 "EHLO
	mail1-ar.fullrate.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3DNGf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 02:35:28 -0400
Message-ID: <516A4E2D.30203@molgaard.org>
Date: Sun, 14 Apr 2013 08:35:25 +0200
From: =?ISO-8859-1?Q?Sune_M=F8lgaard?= <sune@molgaard.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20a1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: WRITE SAME failed in recent kernels
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

In the setting of an SSD and an HDD connected to a HighPoint RocketRAID
620, I am seeing quite a number of log messages such as:

Apr 14 06:02:30 jekaterina kernel: [  952.460537] sd 8:0:1:0: [sde]
Unhandled error code
Apr 14 06:02:30 jekaterina kernel: [  952.460542] sd 8:0:1:0: [sde]
Apr 14 06:02:30 jekaterina kernel: [  952.460544] Result: hostbyte=0x05
driverbyte=0x05
Apr 14 06:02:30 jekaterina kernel: [  952.460546] sd 8:0:1:0: [sde] CDB:
Apr 14 06:02:30 jekaterina kernel: [  952.460548] cdb[0]=0x41: 41 00 a8
c6 fb 78 00 00 18 00
Apr 14 06:02:30 jekaterina kernel: [  952.460557] end_request: I/O
error, dev sde, sector 2831612792
Apr 14 06:02:30 jekaterina kernel: [  952.460566] sde1: WRITE SAME
failed. Manually zeroing.

with sde being the regular HDD.

Now, I am aware that the HighPoint driver, rr62x, isn't part of
mainline, and thus I have contacted HighPoint Technologies as well, but
I would like to know how to ascertain whether this is, indeed, a problem
with their driver, or if it's a problem pertaining to the kernel itself.

Any help, really, is much appreciated, even if it amounts to "HighPoint
is to blame", as I would then have that on higher authority than myself.

Best regards,

Sune Mølgaard

-- 
It's 106 miles to Chicago, we got a full tank of gas, half a pack of
cigarettes, it's dark and we're wearing sunglasses. Hit it.
- Blues Brothers
