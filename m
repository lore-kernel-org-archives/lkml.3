Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaGHEfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 00:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbaGHEfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 00:35:43 -0400
From: Bandan Das <bsd@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
	<53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com>
	<20140704061701.GB3453@kernel> <jpg1ttyhtqw.fsf@redhat.com>
	<20140707084605.GA2904@kernel> <53BA9A91.7090202@redhat.com>
	<jpg38edt6si.fsf@nelium.bos.redhat.com> <53BADA43.8030302@redhat.com>
	<jpgbnt1rrvm.fsf@nelium.bos.redhat.com> <20140707231401.GA5759@kernel>
Date: Tue, 08 Jul 2014 00:35:34 -0400
In-Reply-To: <20140707231401.GA5759@kernel> (Wanpeng Li's message of "Tue, 8
	Jul 2014 07:14:01 +0800")
Message-ID: <jpg8uo4fox5.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <wanpeng.li@linux.intel.com> writes:
...
>
> As Jan metioned in http://www.spinics.net/lists/kvm/msg105238.html, "In any case, 
> unconditionally setting KVM_REQ_EVENT seems strange and should be changed." Your 
> trick still keep the unconditionally setting KVM_REQ_EVENT which is the root cause 
> of the race there, anyway, I focus on fix the hang currently and a patch will be 
> submitted soon. 

Right, that's the plan. Once you submit an updated fix, we can always revert
this change :)
