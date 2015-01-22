Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbbAVTOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:14:50 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:13423 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbbAVTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:14:46 -0500
X-AuditID: cbfec37c-b7f496d000000b40-c6-54c14bd55ab4
Message-id: <54C14BCF.1050902@samsung.com>
Date: Thu, 22 Jan 2015 11:13:19 -0800
From: Mario Smarduch <m.smarduch@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Subject: Re: KVM: CONFIG_LOCK_DEP and CONFIG_LOCK_DETECTOR?
References: <1421919245.13638.50.camel@x220>
In-reply-to: <1421919245.13638.50.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.129.79]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+wr+5V74MhBs+fKVm8eP2P0eLLz+uM
	FnOmFlp8PHWc3WLT42usFpd3zWGzuH2Z1+LvnX9sFvu3/WO1WHTrDLPFp+Y2ZgdujzXz1jB6
	tDT3sHnsnHWX3WPTqk42jzvX9rB5nN+0htlj85J6j/f7rrJ5bNz+hMnj8ya5AK4oLpuU1JzM
	stQifbsErozbL8MLrrJWLOj6zNLAuIuli5GTQ0LAROLHn6VQtpjEhXvr2boYuTiEBJYxSjxY
	soodwullklg/czlUZgujxKKru8FaeAW0JC68nskOYrMIqEpsubSCGcRmE9CV2H9vI1hcVCBC
	4s/pfawQ9YISPybfA+sVEVCWaN18D2wDs8AXJomFd58wdjFycAgLWEv83eYAUiMkoCMxZ+VW
	sF5OoJkXem+AzWQWUJeYNG8RM4QtL7F5zVtmiHpViW03nzNCvKMkMe3wVfYJjMKzkKyehaR9
	FpL2BYzMqxjFSouTC4qT0lMrjPWKE3OLS/PS9ZLzczcxQqKwZgfjva82hxgFOBiVeHi3lB4I
	EWJNLCuuzD3EKMHBrCTCe8ToYIgQb0piZVVqUX58UWlOavEhRiYOTqkGxhYtZpn94V8/GExP
	fyD6ZktLJpuX9V82lpczmmYvOX1atv54yNTHztGOivM4xDz69oWcNIw3m831zalvGdffT3b2
	fRf27DrXdZLD88Pu3LM/v37UWLRq16d7iSuVusVEU3tPbpkcyH7ed8mbbypv/fVrOM5pLz5Z
	bTF9SXq0dsqcsMzer5MS3yqxFGckGmoxFxUnAgBhuxe3oAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 01:34 AM, Paul Bolle wrote:
> Mario,
> 
> Your commit c64735554c0a ("KVM: arm: Add initial dirty page locking
> support") is included in today's linux-next (ie, next-20150122). I
> noticed because a script I use to check linux-next spotted a minor
> problem with it.
> 
> This commit added a comment that mentions CONFIG_LOCK_DEP and
> CONFIG_LOCK_DETECTOR. It seems CONFIG_LOCKDEP and CONFIG_LOCKUP_DETECTOR
> should be used instead. Is a trivial patch to fix these typos queued
> somewhere?
> 
> Thanks,
> 
> 
> Paul Bolle
> 

Hi Paul,
  thanks for spotting that. No there is no trivial patch
queued, didn't notice it until now. Can I submit a follow
up trivial patch later?

- Mario
