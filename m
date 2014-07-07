Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaGGRfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:35:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaGGRfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:35:10 -0400
Message-ID: <53BADA43.8030302@redhat.com>
Date: Mon, 07 Jul 2014 19:34:59 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>	<53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com>	<20140704061701.GB3453@kernel> <jpg1ttyhtqw.fsf@redhat.com>	<20140707084605.GA2904@kernel> <53BA9A91.7090202@redhat.com> <jpg38edt6si.fsf@nelium.bos.redhat.com>
In-Reply-To: <jpg38edt6si.fsf@nelium.bos.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2014 19:31, Bandan Das ha scritto:
>> >
>> > Which patch?  Yours or Bandan's?
> Why don't we hold off on Wanpeng's patch and instead apply the one I proposed
> to call check_nested_events() when checking for interrupt in inject_pending_event() ?

Exactly, yours seemed better to apply as a quick regression fix.

Can you post it as a toplevel patch, so that the commit message explains 
what's happening?  Perhaps add a comment in the code as well.

Paolo

> I think that will take care of https://bugzilla.kernel.org/show_bug.cgi?id=72381
> too. Once, we figure out what's causing hangs under certain conditions with his
> patch, we can apply that and revert this change.
>
>

