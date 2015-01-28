Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbbA2BHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:07:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbbA2BHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:07:16 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ktest: console pty support
Date: Wed, 28 Jan 2015 13:38:37 -0600
Message-Id: <cover.1422473610.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches can be applied on top of yesterday's "ktest: restore tty settings
after closing console" patch.  They create a pty pair for the console to
prevent the console child process from messing up ktest's tty settings.

v2 changes:
- rebased onto the stty save/restore patch
- added a patch to enable user input to the console

Josh Poimboeuf (2):
  ktest: give console process a dedicated tty
  ktest: enable user input to the console

 tools/testing/ktest/ktest.pl | 117 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 93 insertions(+), 24 deletions(-)

-- 
2.1.0

