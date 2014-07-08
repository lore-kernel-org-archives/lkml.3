Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaGHFtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:49:20 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:44926 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaGHFtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:49:18 -0400
Message-ID: <53BB8659.8020500@redhat.com>
Date: Tue, 08 Jul 2014 07:49:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Bandan Das <bsd@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140704061701.GB3453@kernel> <jpg1ttyhtqw.fsf@redhat.com> <20140707084605.GA2904@kernel> <53BA9A91.7090202@redhat.com> <20140707233837.GA6075@kernel>
In-Reply-To: <20140707233837.GA6075@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/07/2014 01:38, Wanpeng Li ha scritto:
> On Mon, Jul 07, 2014 at 03:03:13PM +0200, Paolo Bonzini wrote:
>> Il 07/07/2014 10:46, Wanpeng Li ha scritto:
>>> Hi Paolo,
>>>
>>> Is it ok for you to apply this patch and then more effort should be taken
>>> to figure out the other bug which don't have any relationship with the race
>>> that this patch fixed?
>>
>> Which patch?  Yours or Bandan's?
>
> Please wait, a patch which fix the hang will be submitted soon.

This is a regression, so I think the right thing to do is to apply 
Bandan's patch to 3.16 and yours to 3.17.

Paolo

