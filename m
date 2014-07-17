Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaGQKoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:44:15 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57057 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaGQKoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:44:10 -0400
Message-ID: <53C7A8EE.4040605@redhat.com>
Date: Thu, 17 Jul 2014 12:43:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        "Hu, Robert" <robert.hu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: nVMX: Fix virtual interrupt delivery injection
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com> <53C78F67.1060802@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D4A@SHSMSX104.ccr.corp.intel.com> <20140717091148.GA7744@kernel>
In-Reply-To: <20140717091148.GA7744@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 11:11, Wanpeng Li ha scritto:
>>> >> What hypervisor did you test with? nested_exit_on_intr(vcpu) will
>> >
>> >Jailhouse will clear External-interrupt exiting bit. Am I right? Jan.
>> >
>>> >> return true for both Xen and KVM (nested_exit_on_intr is not the same
>>> >> thing as ACK_INTR_ON_EXIT).
>> >
>> >I guess he want to say External-interrupt exiting bit not ACK_INTR_ON_EXIT.
>> >
> Ah yes, a typo here.

Ok, please repost this patch together with your version of patch 2.

Leave aside patch 3 for now, as I think the original use-after-free 
patch was wrong.

Paolo
