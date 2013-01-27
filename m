Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3A0NVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:21:50 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:42975 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab3A0NVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:21:47 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 27 Jan 2013 14:21:46 +0100
Message-ID: <CA+icZUW1sLS5Z2XOT6=ay2Zq0GuPSFYhLWJuiJkAMt9FUmwKuw@mail.gmail.com>
Subject: [next-20130124][next-20130125] Fix available for broken PM-suspend
From: Sedat Dilek <sedat.dilek@gmail.com>
To: linux-next <linux-next@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is just an information for people might trapping into the same issue.

You can get the patch from patchwork-service [1] or directly from
wq.git# for-3.9-async GIT tree [2].

Next Monday's Linux-Next (next-20130127) should be fine, again.

Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/2042681/
[2] http://git.kernel.org/?p=linux/kernel/git/tj/wq.git;a=commitdiff;h=a0327ff0eda915be623658babacef706099c11a8
