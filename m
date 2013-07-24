Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011Ab3GXEfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3GXEfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:35:31 -0400
Message-ID: <51EF5970.3070504@redhat.com>
Date: Wed, 24 Jul 2013 12:34:56 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: introduce hypervisor_cpuid_base()
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <20130723134855.GA6029@redhat.com>
In-Reply-To: <20130723134855.GA6029@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 09:48 PM, Gleb Natapov wrote:
> On Tue, Jul 23, 2013 at 05:41:02PM +0800, Jason Wang wrote:
>> > This patch introduce hypervisor_cpuid_base() which loop test the hypervisor
>> > existence function until the signature match and check the number of leaves if
>> > required. This could be used by Xen/KVM guest to detect the existence of
>> > hypervisor.
>> > 
> Looks good to me.
>
> Since this touches common code, kvm and xen I expect this to be taken
> via the tip tree, correct?
>
Yes, I think so.
