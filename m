Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaCZJic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:38:32 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33635 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaCZJia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:38:30 -0400
Message-ID: <5332A010.9010508@redhat.com>
Date: Wed, 26 Mar 2014 10:38:24 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>, Peter Wu <peter@lekensteyn.nl>,
        Gleb Natapov <gleb@kernel.org>
CC: Venkatesh Srinivas <venkateshs@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
References: <4055058.qLAukpngnj@al> <1558917.OgpeoK0IhF@al> <20140322122758.GA4292@minantech.com> <7070151.NcmQcQO4az@al> <E959C4978C3B6342920538CF579893F001E80FC4@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F001E80FC4@SHSMSX104.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/03/2014 08:23, Wu, Feng ha scritto:
> Is there a solution for this issue right now? I also met this GPF crash.

Can you attach your .config?

Paolo

