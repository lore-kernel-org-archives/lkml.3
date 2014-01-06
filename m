Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaAFR4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 12:56:32 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49782 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAFR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:56:31 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 0/1] Makefile: Use CPPFLAGS from the environment
Date: Mon,  6 Jan 2014 11:56:24 -0600
Message-Id: <1389030985-26657-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Here's another patch for trace-cmd that I'm using in Debian. Please
consider it for your tree.

It also looks like you haven't applied the patches I sent a few months
back [1][2]. I'm guessing you just forgot about them, but please let me
know if there's something I need to fix. I also pushed out all of these
patches if you'd prefer to do a pull:

  git://kernel.ubuntu.com/sforshee/trace-cmd.git for-upstream

Thanks,
Seth

[1] http://www.spinics.net/lists/kernel/msg1625190.html
[2] http://www.spinics.net/lists/kernel/msg1629025.html
