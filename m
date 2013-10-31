Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3JaKyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 06:54:50 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33207 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab3JaKys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 06:54:48 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/3] Small patches around kvm doc
Date: Thu, 31 Oct 2013 16:16:33 +0530
Message-Id: <1383216396-12869-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was going through the kvm documentation when I noticed the following
minor nits.

Thanks.

Ramkumar Ramachandra (3):
  MAINTAINERS: fix broken link to www.linux-kvm.org
  Documentation/kvm: patches should be against linux.git
  Documentation/kvm: add a 00-INDEX file

 Documentation/virtual/kvm/00-INDEX             | 24 ++++++++++++++++++++++++
 Documentation/virtual/kvm/review-checklist.txt |  2 +-
 MAINTAINERS                                    |  2 +-
 3 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/virtual/kvm/00-INDEX

-- 
1.8.5.rc0

