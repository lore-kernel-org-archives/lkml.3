Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaBIVtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 16:49:09 -0500
Received: from smtp.outflux.net ([198.145.64.163]:40385 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaBIVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 16:49:05 -0500
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        keescook@chromium.org
Subject: [PATCH 0/3] lkdtm: various clean ups, new test
Date: Sun,  9 Feb 2014 13:48:45 -0800
Message-Id: <1391982528-21083-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the printk() uses and replaces them with pr_* calls,
fixes execution tests to include an icache flush, and adds a new
test for checking the kernel code memory is not writable.

-Kees
