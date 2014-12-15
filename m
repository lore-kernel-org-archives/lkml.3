Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbaLOGNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:13:25 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43252 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaLOGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:13:23 -0500
From: Kevin Cernekee <cernekee@gmail.com>
To: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk
Cc: computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/4] Stop maintainer abuse
Date: Sun, 14 Dec 2014 22:09:46 -0800
Message-Id: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series amends the kernel development process to reduce the
load on key maintainers during peak periods, by discouraging the submission
of non-urgent patches while the merge window is open.

Original discussion here:

https://lkml.org/lkml/2014/12/12/772

(As a non-subsystem-maintainer I don't really have a horse in this race,
but if everyone else agrees that it's the right thing to do, we might as
well make it the official policy and start teaching it to new developers.)


Kevin Cernekee (4):
  Documentation: Change policy on sending patches during merge window
  Documentation/SubmitChecklist: Remind submitters to check the merge
    window
  Documentation: Add cutoff periods for patch acceptance
  Documentation: Provide suggestions on when to repost patches

 Documentation/SubmitChecklist                     |  5 +++++
 Documentation/development-process/5.Posting       | 25 +++++++++++++++++++++++
 Documentation/development-process/6.Followthrough |  5 ++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

-- 
2.1.1

