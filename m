Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3JKAUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:20:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60986 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab3JKASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:18:48 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
Subject: [PATCH v8 0/6] Kernel base address randomization
Date: Thu, 10 Oct 2013 17:18:12 -0700
Message-Id: <1381450698-28710-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to the kASLR series. The improved e820 walking code from v7 has been
reorganized, and now explicitly avoids unsafe memory regions instead of
raising the minimum load address.

-Kees

