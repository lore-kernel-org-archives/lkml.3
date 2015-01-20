Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbbATP03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:26:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbbATP02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:26:28 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Seth Jennings <sjenning@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] support for stacked patches
Date: Tue, 20 Jan 2015 09:26:17 -0600
Message-Id: <cover.1421767360.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for properly stacking patches.  This includes enforcing patch stack
semantics and allowing functions to be repatched.

v2 changes:
- add "enforce stacking semantics" patch
- add documentation comments for new klp_ops struct

Josh Poimboeuf (2):
  livepatch: enforce patch stacking semantics
  livepatch: support for repatching a function

 include/linux/livepatch.h |   4 +-
 kernel/livepatch/core.c   | 180 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 131 insertions(+), 53 deletions(-)

-- 
2.1.0

