Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaHUSvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:51:20 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48738 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbaHUSvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:51:18 -0400
Message-ID: <53F63FD5.5040305@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 00:22:05 +0530
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
Subject: Re: [PATCH v3 3/7] KVM: VMX: make PLE window per-VCPU
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-4-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082118-0005-0000-0000-0000009986D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> Change PLE window into per-VCPU variable, seeded from module parameter,
> to allow greater flexibility.
>
> Brings in a small overhead on every vmentry.
>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>

with intelligent update in patch 7
Reviewed-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>

