Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaGGXhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:37:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:29309 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaGGXhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,621,1400050800"; 
   d="scan'208";a="569652720"
Date: Tue, 8 Jul 2014 07:38:37 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Bandan Das <bsd@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140707233837.GA6075@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
 <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
 <20140704061701.GB3453@kernel>
 <jpg1ttyhtqw.fsf@redhat.com>
 <20140707084605.GA2904@kernel>
 <53BA9A91.7090202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BA9A91.7090202@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 03:03:13PM +0200, Paolo Bonzini wrote:
>Il 07/07/2014 10:46, Wanpeng Li ha scritto:
>>Hi Paolo,
>>
>>Is it ok for you to apply this patch and then more effort should be taken
>>to figure out the other bug which don't have any relationship with the race
>>that this patch fixed?
>
>Which patch?  Yours or Bandan's?

Please wait, a patch which fix the hang will be submitted soon.

Regards,
Wanpeng Li 

>
>Paolo
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
