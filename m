Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaBUVgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:36:33 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50921 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbaBUVga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:36:30 -0500
Message-ID: <5307C6D9.4030503@redhat.com>
Date: Fri, 21 Feb 2014 22:36:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] kvm: Use pci_enable_msix_exact() instead of pci_enable_msix()
References: <1392804931-30671-11-git-send-email-agordeev@redhat.com> <5304B09D.7010900@redhat.com> <20140221170414.GM17353@dhcp-26-207.brq.redhat.com> <20140221170504.GN17353@dhcp-26-207.brq.redhat.com> <530788C1.6030109@redhat.com> <20140221185620.GA18725@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140221185620.GA18725@dhcp-26-207.brq.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2014 19:56, Alexander Gordeev ha scritto:
> On Fri, Feb 21, 2014 at 06:11:29PM +0100, Paolo Bonzini wrote:
>> It's okay, but it's not clear to me whether I should include this
>> patch or someone else will. :)
>
> Please, include it.

And where do I get pci_enable_msix_exact?  When will pci_enable_msix 
disappear?

So, do I have to pull something (which I'd rather not, since pulling the 
wrong thing in a submaintainer tree will make Linus angry), or should I 
do it in the next merge window after pci_enable_msix_exact gets in?

All in all, it seems much simpler to me if the linux-pci tree just 
includes the whole patch series with my Acked-by.

Paolo

> Thanks!
>
>> Paolo
>

