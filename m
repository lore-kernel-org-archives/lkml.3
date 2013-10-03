Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3JCUxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:53:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47061 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab3JCUxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:53:50 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
Subject: [PATCH v7 0/7] Kernel base address randomization on x86
Date: Thu,  3 Oct 2013 13:53:18 -0700
Message-Id: <1380833605-26313-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated from v6 with some suggestions from HPA.

As before, this detects and uses various available randomness sources to
choose an available slot from the e820 regions for kernel base address
relocation.

This is rolled out on Chrome OS devices, and working well.

-Kees

