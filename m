Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbaFSLh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 07:37:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129AbaFSLh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 07:37:58 -0400
Message-ID: <53A2CB92.3040601@redhat.com>
Date: Thu, 19 Jun 2014 13:37:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>
CC: linux-kernel@vger.kernel.org, gleb@kernel.org
Subject: Re: [PATCH 12/25] KVM: emulate: extend memory access optimization
 to stores
References: <1402318753-23362-1-git-send-email-pbonzini@redhat.com>	<1402318753-23362-13-git-send-email-pbonzini@redhat.com> <jpg61kaexkc.fsf@redhat.com>
In-Reply-To: <jpg61kaexkc.fsf@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/06/2014 20:40, Bandan Das ha scritto:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>
>> > Even on a store the optimization saves about 50 clock cycles,
>> > mostly because the jump in write_memory_operand becomes much more
>> > predictable.
>> >
>> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
>> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Isn't the reviewed-by automatically implied ? :)
>

This patch breaks x86/vmx.flat, but apart from this the series passes 
Autotest and kvm-unit-tests.  I'm going to leave the memory access 
optimization out, and push the rest to kvm/queue.

Paolo
