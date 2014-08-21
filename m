Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaHUJbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:31:46 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:48322 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbaHUJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:31:45 -0400
Message-ID: <53F5BC7B.8010607@redhat.com>
Date: Thu, 21 Aug 2014 11:31:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] KVM: nVMX: introduce apic_access_and_virtual_page_valid
References: <1408527905-11705-1-git-send-email-wanpeng.li@linux.intel.com> <1408527905-11705-2-git-send-email-wanpeng.li@linux.intel.com> <53F47D7E.1080306@redhat.com> <20140821080833.GB30303@kernel>
In-Reply-To: <20140821080833.GB30303@kernel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 10:08, Wanpeng Li ha scritto:
>> >Thanks Wanpeng.  The code now looks good.  Just one thing: please swap
>> >them, so that the series remains bisectable.
>> >
> Do you mean the first patch introduce nested_get_vmcs12_pages() and the
> second patch implement nested TPR shadow/threshold emulation?
> 

Yes, exactly.

Paolo
