Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3KKGPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 01:15:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab3KKGPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 01:15:31 -0500
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [BUG]: DELL XPS 8500 become a brick after fill too many entries to nvram.
Date: Mon, 11 Nov 2013 14:15:22 +0800
Message-ID: <87fvr3h3b9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy all,
  For now we ensure at least ~5kb free space. But my dell xps still
  become a brick after I add too many entries to my nvram. So maybe 5kb
  is not safe enough. and 5kb is just aginst Samsung's laptop.
  So should we enlarge EFI_MIN_RESERVE?
-- 
Best,
Madper Xie.
