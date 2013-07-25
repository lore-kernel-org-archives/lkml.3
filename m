Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3GYINa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab3GYIN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:13:27 -0400
Message-ID: <51F0DE01.50607@redhat.com>
Date: Thu, 25 Jul 2013 16:12:49 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86: properly handle kvm emulation of hyperv
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <1374572465-15278-4-git-send-email-jasowang@redhat.com> <bd93bc49300a4d99996cc4f57c19a008@SN2PR03MB061.namprd03.prod.outlook.com> <51EE97BD.4050402@zytor.com> <51EF59FB.8040207@redhat.com> <51EF5C9C.6070403@zytor.com> <51EF7A2A.6040003@redhat.com> <51EF7CFB.8030104@redhat.com> <ddd4ff1d4b124faeb18e6a0ba8ae2128@BLUPR03MB050.namprd03.prod.outlook.com> <ba894640-b367-44f0-a5e2-89a2edf4951a@email.android.com> <f69678c6673e4168ae244fb6325060bc@BLUPR03MB050.namprd03.prod.outlook.com> <889e20ee-7655-4fdc-b30a-150b8604ca0f@email.android.com> <51F0DAD1.8080108@redhat.com>
In-Reply-To: <51F0DAD1.8080108@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 03:59 PM, Paolo Bonzini wrote:
> Il 24/07/2013 23:37, H. Peter Anvin ha scritto:
>> What I'm suggesting is exactly that except that the native hypervisor is later in CPUID space.
> Me too actually.
>
> I was just suggesting an implementation of the idea (that takes into
> account hypervisors detected by other means than CPUID).
>
> Paolo

This make sense, will send V2.

Thanks
>> KY Srinivasan <kys@microsoft.com> wrote:
>>> As Paolo suggested if there were some priority encoded, the guest could make an
>>> informed decision. If the guest under question can run on both hypervisors A and B,
>>> we would rather the guest discover hypervisor A when running on A and
>>> hypervisor B when running on B. The priority encoding could be as simple as
>>> surfacing the native hypervisor signature earlier in the CPUID space.

