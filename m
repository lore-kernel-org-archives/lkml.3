Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaJZMRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 08:17:04 -0400
Received: from fep31.mx.upcmail.net ([62.179.121.49]:34996 "EHLO
	fep31.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJZMRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 08:17:01 -0400
X-SourceIP: 77.56.27.120
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <544CE637.7000406@odi.ch>
Date: Sun, 26 Oct 2014 13:16:55 +0100
From: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lv Zheng <lv.zheng@intel.com>, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ACPI regression: New Acer workarounds break Samsung NP900X
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lv,

These two patches introduce a regression for Samsung notebooks and they no 
longer get ACPI interrupts for plugging the power adapter or LID switches.

Multiple people have verified that reverting these patches makes the regression 
go away.

Please see new comments in:
https://bugzilla.kernel.org/show_bug.cgi?id=44161#c184

 From 3afcf2ece453e1a8c2c6de19cdf06da3772a1b08 Mon Sep 17 00:00:00 2001
From: Lv Zheng <lv.zheng@intel.com>
Date: Thu, 21 Aug 2014 14:41:13 +0800
Subject: [PATCH] ACPI / EC: Add support to disallow QR_EC to be issued when
  SCI_EVT isn't set

 From 558e4736f2e1b0e6323adf7a5e4df77ed6cfc1a4 Mon Sep 17 00:00:00 2001
From: Lv Zheng <lv.zheng@intel.com>
Date: Thu, 21 Aug 2014 14:41:26 +0800
Subject: [PATCH] ACPI / EC: Add support to disallow QR_EC to be issued before
  completing previous QR_EC


Thanks,

Ortwin


