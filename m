Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaB0IqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:46:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:41454 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaB0IqS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Thu, 27 Feb 2014 03:46:18 -0500
Message-Id: <530F0973020000780011FBE2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 27 Feb 2014 08:46:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <davem@davemloft.net>, <dborkman@redhat.com>, <ffusco@redhat.com>,
        <tgraf@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] x86/hash: miscellaneous fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1: fix build failure with older binutils
2: x86/hash: swap arguments passed to crc32_u32()
3: cleanup

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Daniel Borkmann <dborkman@redhat.com>
Cc: Thomas Graf <tgraf@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
---
v2: 2nd patch now swaps arguments rather than parameters, as
requested by hpa


