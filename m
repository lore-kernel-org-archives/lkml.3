Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3I1SSV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:18:21 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46865 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3I1SST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com>
References: <CAF1_xX2=BYkEn3ycM4smREqk-ioGbvu8Ea4or22U-jBdKmDKGA@mail.gmail.com>
Date: Sat, 28 Sep 2013 20:18:18 +0200
Message-ID: <CAF1_xX0suiHSgqWRBrA66qc1A_32Xq08hOikM2VSwQOEgRH-RA@mail.gmail.com>
Subject: Fwd: [v3.12-rc1] [regression] PM / hibernate: Create memory bitmaps
 after freezing user space
From: Ronald <ronald645@gmail.com>
To: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ resend, forgot to disable HTML (sorry!) ]

Dear kernel developers,

Commit 8fd37a4c9 (PM / hibernate: Create memory bitmaps after freezing
user space) causes resume to fail.

Only, when using the s2disk utility (through pm-hibernate).

Not when I do:

echo -n "disk" > /sys/power/state

Reverting the commit did not work.

I am using a encrypted LUKS partition with a temporary key that is
functioning as the swap device used for the suspend image.

Awaiting further orders....

                                        Ronald
