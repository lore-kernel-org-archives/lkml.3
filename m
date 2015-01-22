Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbbAVN5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:57:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56685 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbbAVN5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:57:32 -0500
Message-ID: <54C101B9.1050804@redhat.com>
Date: Thu, 22 Jan 2015 14:57:13 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Mario Smarduch <m.smarduch@samsung.com>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: KVM: HAVE_KVM_ARCH_DIRTY_LOG_PROTECT?
References: <1421918381.13638.43.camel@x220>
In-Reply-To: <1421918381.13638.43.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/01/2015 10:19, Paul Bolle wrote:
> Your commit ba0513b5b8ff ("KVM: Add generic support for dirty page
> logging") is included in today's linux-next (ie, next-20150122). I
> noticed because a script I use to check linux-next spotted a problem
> with it.
> 
> That commit added a Kconfig symbol HAVE_KVM_ARCH_DIRTY_LOG_PROTECT. But
> nothing in linux-next uses that symbol. Why was it added?

Ah, there are two Kconfig symbols added by mistake.

+config HAVE_KVM_ARCH_DIRTY_LOG_PROTECT
+ bool
+
+config KVM_GENERIC_DIRTYLOG_READ_PROTECT
+ bool

Christoffer, can you fix that in kvm-arm and also the other mistake that
Paul reported?

Paolo
