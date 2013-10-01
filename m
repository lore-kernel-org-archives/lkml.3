Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3JATiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:38:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:52964 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab3JAThx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:37:53 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com,
        Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com,
        Mathias Krause <minipli@googlemail.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
Subject: [PATCH v6 0/7] Kernel base address randomization
Date: Tue,  1 Oct 2013 12:37:18 -0700
Message-Id: <1380656245-29975-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the latest version of the kASLR series. It has much improved
e820 walking code, and expands the window available on 64-bit.

This is rolled out on Chrome OS devices, and working well.

-Kees

