Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaGGNDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:03:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbaGGNDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:03:22 -0400
Message-ID: <53BA9A91.7090202@redhat.com>
Date: Mon, 07 Jul 2014 15:03:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>, Bandan Das <bsd@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140704061701.GB3453@kernel> <jpg1ttyhtqw.fsf@redhat.com> <20140707084605.GA2904@kernel>
In-Reply-To: <20140707084605.GA2904@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2014 10:46, Wanpeng Li ha scritto:
> Hi Paolo,
>
> Is it ok for you to apply this patch and then more effort should be taken
> to figure out the other bug which don't have any relationship with the race
> that this patch fixed?

Which patch?  Yours or Bandan's?

Paolo
