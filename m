Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab3GXEpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:45:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3GXEpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:45:03 -0400
Message-ID: <51EF5BAE.1020905@redhat.com>
Date: Wed, 24 Jul 2013 12:44:30 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: introduce hypervisor_cpuid_base()
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <51EE553C.40305@zytor.com> <51EE65F4.3000703@redhat.com> <51EEA96D.3070208@zytor.com>
In-Reply-To: <51EEA96D.3070208@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 12:03 AM, H. Peter Anvin wrote:
> On 07/23/2013 04:16 AM, Paolo Bonzini wrote:
>> That's nicer, though strcmp is what the replaced code used to do in
>> patches 2 and 3.
>>
>> Note that memcmp requires the caller to use "KVMKVMKVM\0\0" as the
>> signature (or alternatively hypervisor_cpuid_base can copy the argument
>> into another 12-byte local variable).
>>
> Which is the actual signature, though...
>
> 	-hpa
>
>

Since it's just a minor optimization. How about just keep using the
strcmp()?
