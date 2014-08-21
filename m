Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaHUStk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:49:40 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56743 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaHUStj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:49:39 -0400
Message-ID: <53F63F74.3010500@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 00:20:28 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 2/7] KVM: x86: introduce sched_in to kvm_x86_ops
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-3-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082118-0013-0000-0000-0000002208DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> sched_in preempt notifier is available for x86, allow its use in
> specific virtualization technlogies as well.
>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>

Reviewed-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>

