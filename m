Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaHEKAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 06:00:41 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:58819 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbaHEKAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 06:00:39 -0400
Message-ID: <53E0AB44.90804@imgtec.com>
Date: Tue, 5 Aug 2014 11:00:36 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Alexander Graf <agraf@suse.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the kvm tree
References: <20140804180403.3cfdbadf@canb.auug.org.au>
In-Reply-To: <20140804180403.3cfdbadf@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 04/08/14 09:04, Stephen Rothwell wrote:
>  +  PPC   | KVM_REG_PPC_LPCR              | 64

I think due to a0840240c0c6 this one should be s/64/32/.

> ++  PPC   | KVM_REG_PPC_LPCR_64		| 64

And I suppose it'd be nice to replace tabs with spaces for consistency
(since that's one of the things bf5590f37919 did).

How about this fixup patch?

Cheers
James

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index dc226e1867e1..2863f02b0efb 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1895,8 +1895,8 @@ registers, find a list below:
   PPC   | KVM_REG_PPC_PID               | 64
   PPC   | KVM_REG_PPC_ACOP              | 64
   PPC   | KVM_REG_PPC_VRSAVE            | 32
-  PPC   | KVM_REG_PPC_LPCR              | 64
-  PPC   | KVM_REG_PPC_LPCR_64		| 64
+  PPC   | KVM_REG_PPC_LPCR              | 32
+  PPC   | KVM_REG_PPC_LPCR_64           | 64
   PPC   | KVM_REG_PPC_PPR               | 64
   PPC   | KVM_REG_PPC_ARCH_COMPAT       | 32
   PPC   | KVM_REG_PPC_DABRX             | 32
