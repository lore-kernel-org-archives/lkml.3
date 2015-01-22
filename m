Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbbAVRsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:48:14 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8513 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbbAVRsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:48:01 -0500
X-AuditID: cbfec37a-b7fba6d000007572-41-54c137cf6dc3
Message-id: <54C137C9.1060906@samsung.com>
Date: Thu, 22 Jan 2015 09:47:53 -0800
From: Mario Smarduch <m.smarduch@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: KVM: HAVE_KVM_ARCH_DIRTY_LOG_PROTECT?
References: <1421918381.13638.43.camel@x220> <54C0E2FF.6050607@redhat.com>
In-reply-to: <54C0E2FF.6050607@redhat.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.129.79]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9hP93z5gdDDJZv07J48fofo8WXn9cZ
	LeZMLbS4vGsOm8X+bf9YLRbdOsNs8am5jdmB3WPnrLvsHptWdbJ53Lm2h83j/b6rbB4btz9h
	8vi8SS6ALYrLJiU1J7MstUjfLoEr49+1BsaCnywVU/6eYW5gfM/cxcjJISFgIvFv0lN2CFtM
	4sK99WxdjFwcQgLLGCXmr3oL5fQySTx/NRfK2cIo0TBhHZDDwcEroCVx4VU+SDeLgKrEgg2v
	WEBsNgFdif33NoJNFRWIkPhzeh8riM0rICjxY/I9sBoRAXWJhlOvWUFmMgvcY5ToaVrFBJIQ
	FjCSeHH8JyOILSTgJbF7xzWwZk6gXc/nXmMDsZmBmifNW8QMYctLbF7zlhmiXlVi283njBDv
	KElMO3yVfQKj8Cwku2chaZ+FpH0BI/MqRrHS4uSC4qT01ApDveLE3OLSvHS95PzcTYyQ2Kna
	wXjnq80hRgEORiUe3oziAyFCrIllxZW5hxglOJiVRHiPGB0MEeJNSaysSi3Kjy8qzUktPsTI
	xMEp1cBYt9zh9VUeVT23WWkM2xd3O+zcrntFd9ETzoBVgeW9M9Ik+edZlG5rlYl+1i//yNVp
	Fc+TRUs+li03PrOc0c0hb+m0VP5ZCdmeP8ztz7qy7rFfc3wSt/ektI3O2399vBHDOuGX4dIF
	Xvd2fFq4W+PYD6s2Z/H1lZpFWzWy1I2PPlnrmTj7wJoSJZbijERDLeai4kQA293X83sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 03:46 AM, Paolo Bonzini wrote:
> 
> 
> On 22/01/2015 10:19, Paul Bolle wrote:
>> Mario,
>>
>> Your commit ba0513b5b8ff ("KVM: Add generic support for dirty page
>> logging") is included in today's linux-next (ie, next-20150122). I
>> noticed because a script I use to check linux-next spotted a problem
>> with it.
>>
>> That commit added a Kconfig symbol HAVE_KVM_ARCH_DIRTY_LOG_PROTECT. But
>> nothing in linux-next uses that symbol. Why was it added?
> 
> That's a bug.  I'll fix it when pulling from the kvm-arm tree.
> 
> Paolo
> 

Paolo,
   thanks, left over from early iteration.

- Mario
