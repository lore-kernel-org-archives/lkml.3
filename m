Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaFEL5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:57:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaFEL5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:57:11 -0400
Message-ID: <53905B14.5020204@suse.de>
Date: Thu, 05 Jun 2014 13:57:08 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 0/3] Prepare for in-kernel VFIO DMA operations acceleration
References: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1401953144-19186-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05.06.14 09:25, Alexey Kardashevskiy wrote:
> This reserves 2 capability numbers.
>
> This implements an extended version of KVM_CREATE_SPAPR_TCE_64 ioctl.
>
> Please advise how to proceed with these patches as I suspect that
> first two should go via Paolo's tree while the last one via Alex Graf's tree
> (correct?).

They would just go via my tree, but only be actually allocated (read: 
mergable to qemu) when they hit Paolo's tree.

In fact, I don't think it makes sense to split them off at all.


Alex

