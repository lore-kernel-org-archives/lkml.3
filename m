Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966AbaCIFL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 00:11:28 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55868 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaCIFL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 00:11:27 -0500
MIME-Version: 1.0
Date: Sun, 9 Mar 2014 10:41:26 +0530
Message-ID: <CAFB2WuW19WdFcHDe5jxtq7v8+PL41OjBEZLYfaCEH=1axWpYEA@mail.gmail.com>
Subject: Reg: Staging Driver: lustre/lustre/lov
From: Monam Agarwal <monamagarwal123@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, josh@joshtriplett.org,
        dulshani.gunawardhana89@gmail.com, joe@perches.com,
        "Xiong, Jinshan" <jinshan.xiong@intel.com>, john.hammond@intel.com,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was going through lov_pack.c and in the function lov_unpackmd before
checking for lmm we are using the lmm_pattern value and doing
allocation. In case lmm is null use of pattern =
le32_to_cpu(lmm->lmm_pattern); will throw a null pointer exception.

I was thinking of moving the null check above but i that case what
will be the allocation pattern?

Regards,
Monam Agarwal
