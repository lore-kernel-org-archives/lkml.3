Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaAXTKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:10:39 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34811 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbaAXTKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:10:33 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/3] memblock, x86: fix big numa system booting
Date: Fri, 24 Jan 2014 11:11:07 -0800
Message-Id: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Big numa system boot get broken while switch API from bootmem to
memblock_virt.

Revert the offending patch, and also address swiotlb regression.

Thanks

Yinghai
