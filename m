Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3FVShg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 14:37:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46204 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3FVShf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 14:37:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: [PATCH 0/4] lkdtm: various improvements
Date: Sat, 22 Jun 2013 11:37:03 -0700
Message-Id: <1371926227-2609-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds several new test targets that have been useful when
testing various kernel crash conditions while working on Chrome OS,
and corrects the CORRUPT_STACK trigger as well.

Thanks,

-Kees

