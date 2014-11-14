Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270AbaKNLMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:12:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48145 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132AbaKNLMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:12:34 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, imammedo@redhat.com
Subject: [PATCH 0/3] KVM: simplification to the memslots code
Date: Fri, 14 Nov 2014 12:11:59 +0100
Message-Id: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Igor and Takuya,

here are a few small patches that simplify __kvm_set_memory_region
and associated code.  Can you please review them?

Thanks,

Paolo

Paolo Bonzini (3):
  kvm: memslots: track id_to_index changes during the insertion sort
  kvm: commonize allocation of the new memory slots
  kvm: simplify update_memslots invocation

 virt/kvm/kvm_main.c | 87 ++++++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 51 deletions(-)

-- 
1.8.3.1

