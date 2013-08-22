Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3HVMSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:18:32 -0400
Received: from relay.parallels.com ([195.214.232.42]:35457 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab3HVMSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:18:31 -0400
Message-ID: <5216018D.7000509@parallels.com>
Date: Thu, 22 Aug 2013 16:18:21 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <Xen-devel@lists.xen.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Regression: x86/mm: new _PTE_SWP_SOFT_DIRTY bit conflicts with
 existing use
References: <5214C524.1050900@citrix.com> <20130821141223.GS18673@moon> <5214F09002000078000ED5C3@nat28.tlf.novell.com> <20130821154238.GV18673@moon> <521500E102000078000ED65C@nat28.tlf.novell.com> <20130821161946.GW18673@moon> <5215D23A02000078000ED7FC@nat28.tlf.novell.com> <20130822070305.GH18673@moon> <5215D99102000078000ED838@nat28.tlf.novell.com> <20130822112727.GL18673@moon> <5216134502000078000EDA3D@nat28.tlf.novell.com>
In-Reply-To: <5216134502000078000EDA3D@nat28.tlf.novell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 03:33 PM, Jan Beulich wrote:

>> From: Cyrill Gorcunov <gorcunov@gmail.com>
>> Subject: [PATCH] mm: Make sure _PAGE_SWP_SOFT_DIRTY bit is not set on 
>> present pte
>>
>> _PAGE_SOFT_DIRTY bit should never be set on present pte so add
>> VM_BUG_ON to catch any potential future abuse.
>>
>> Also add a comment on _PAGE_SWP_SOFT_DIRTY definition explaining
>> scope of its usage.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> Acked-by: Jan Beulich <jbeulich@suse.com>

Acked-by: Pavel Emelyanov <xemul@parallels.com>
