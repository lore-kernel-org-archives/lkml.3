Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaHUTRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:17:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:59075 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaHUTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:17:39 -0400
Message-ID: <53F64605.7010807@linux.vnet.ibm.com>
Date: Fri, 22 Aug 2014 00:48:29 +0530
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
Subject: Re: [PATCH v3 7/7] KVM: VMX: optimize ple_window updates to VMCS
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-8-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-8-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082119-2674-0000-0000-000001808737
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:38 PM, Radim Krčmář wrote:
> ple_window is preserved in VMCS, so can write it only after a change.
> Do this by keeping a dirty bit.
>
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>

Reviewed-by: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>


