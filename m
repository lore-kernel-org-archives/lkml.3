Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3EWMum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:50:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48226 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab3EWMuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:50:40 -0400
From: Ben Minerds <puzzleduck@gmail.com>
To: greg@kroah.com, rob@landley.net
Cc: Ben Minerds <PuZZleDucK@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Documentation: Updating docs and links relating to patches.
Date: Thu, 23 May 2013 22:49:52 +1000
Message-Id: <cover.1369312746.git.PuZZleDucK@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This patch series 1. adds "the perfect patch" doc 2. adds "submission format"
 doc 3. update refs to perfect-patch 4. fix link in perfect patch 5. update
 refs to sub-format 6. fix source ref in perfect patch 7. reformat  submission
 format doc 8. move other documents into patch sub directory.

Ben Minerds (8):
  Documentation: Adding "The Perfect Patch" by Andrew Morton
  Documentation: Adding "Linux Kernel Patch Submission Format"
  Documentation: Replacing references to broken perfect patch URL
  Documentation: Replacing reference to broken perfect patch URL
  Documentation: Replacing reference to broken submission format URL
  Documentation: Updating a broken link in "the perfect patch"
  Documentation: Reformatting "Linux Kernel Patch Submission Format"
  Documentation: Move other patch related document

 Documentation/HOWTO                                |  12 +-
 Documentation/SubmittingPatches                    | 743 ---------------------
 Documentation/applying-patches.txt                 | 454 -------------
 .../patches/Patch-Submission-Format.txt            | 131 ++++
 .../development-process/patches/SubmittingPatches  | 743 +++++++++++++++++++++
 .../patches/The-Perfect-Patch.txt                  | 167 +++++
 .../patches/applying-patches.txt                   | 454 +++++++++++++
 Documentation/ja_JP/HOWTO                          |  10 +-
 Documentation/ja_JP/SubmittingPatches              |   4 +-
 Documentation/ko_KR/HOWTO                          |   6 +-
 Documentation/zh_CN/HOWTO                          |   6 +-
 Documentation/zh_CN/SubmittingPatches              |   4 +-
 12 files changed, 1516 insertions(+), 1218 deletions(-)
 delete mode 100644 Documentation/SubmittingPatches
 delete mode 100644 Documentation/applying-patches.txt
 create mode 100644 Documentation/development-process/patches/Patch-Submission-Format.txt
 create mode 100644 Documentation/development-process/patches/SubmittingPatches
 create mode 100644 Documentation/development-process/patches/The-Perfect-Patch.txt
 create mode 100644 Documentation/development-process/patches/applying-patches.txt

-- 
1.8.1.2

