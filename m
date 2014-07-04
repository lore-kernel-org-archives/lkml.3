Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaGDHqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaGDHqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:46:50 -0400
Message-ID: <53B65BDE.9090902@redhat.com>
Date: Fri, 04 Jul 2014 09:46:38 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com> <53B3CA6A.4050902@siemens.com> <jpgy4wb9g5t.fsf@redhat.com> <20140703065955.GA4236@kernel> <jpgk37u8iae.fsf@redhat.com> <20140704025250.GA2849@kernel> <53B63EF2.6000800@siemens.com> <20140704060831.GA3453@kernel> <53B6559A.6020406@siemens.com> <20140704073923.GA7188@kernel>
In-Reply-To: <20140704073923.GA7188@kernel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2014 09:39, Wanpeng Li ha scritto:
> PASS: test vmxon with FEATURE_CONTROL cleared
> PASS: test vmxon without FEATURE_CONTROL lock
> PASS: test enable VMX in FEATURE_CONTROL
> PASS: test FEATURE_CONTROL lock bit
> PASS: test vmxon
> PASS: test vmptrld
> PASS: test vmclear
> PASS: test vmptrst
> PASS: test vmxoff

You are not running the latest versions of the tests.

Paolo
