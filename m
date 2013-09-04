Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab3IDUeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:34:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760211Ab3IDUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:34:12 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] kvm: fix a bug and remove a redundancy in async_pf
Date: Wed,  4 Sep 2013 22:32:22 +0200
Message-Id: <1378326744-24434-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did not reproduce the bug fixed in [1/2], but there are not that many
reasons why we could not unload a module, so the spot is quite obvious.


Radim Krčmář (2):
  kvm: free resources after canceling async_pf
  kvm: remove .done from struct kvm_async_pf

 include/linux/kvm_host.h | 1 -
 virt/kvm/async_pf.c      | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
1.8.3.1

