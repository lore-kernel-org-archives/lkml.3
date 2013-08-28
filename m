Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3H1O0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:26:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab3H1O0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:26:51 -0400
Subject: Re: [PATCH] KVM: PPC: Book3S PR: return appropriate error when allocation fails
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1374073829-28246-1-git-send-email-cascardo@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 16:26:46 +0200
Cc: linuxppc-dev@lists.ozlabs.org, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <79F3EE64-D747-4546-B353-2EBE2DEE86E6@suse.de>
References: <1374073829-28246-1-git-send-email-cascardo@linux.vnet.ibm.com>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 17.07.2013, at 17:10, Thadeu Lima de Souza Cascardo wrote:

> err was overwritten by a previous function call, and checked to be 0. If
> the following page allocation fails, 0 is going to be returned instead
> of -ENOMEM.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Thanks, applied to kvm-ppc-queue.


Alex

