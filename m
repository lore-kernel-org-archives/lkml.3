Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaHSX6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 19:58:18 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41585 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaHSX6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 19:58:16 -0400
Message-ID: <53F3E490.1060400@gmail.com>
Date: Wed, 20 Aug 2014 07:58:08 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@kernel.org, kvm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to
 '-1' after free it
References: <53E4EED7.6050302@gmail.com> <53F370CD.80201@gmail.com> <53F37221.5020508@redhat.com>
In-Reply-To: <53F37221.5020508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 11:49 PM, Paolo Bonzini wrote:
> Il 19/08/2014 17:44, Chen Gang ha scritto:
>> > Hello maintainers:
>> > 
>> > Please help check this patch, when you have time.
> Hi, it's already on its way to 3.17-rc2, but I first have to run a bunch
> of tests.

OK, thanks. Also can let me try the test, although I am not quite
familiar with KVM. Since I plan to focus on KVM/Xen next, I shall
construct related environments for its' common test, at least.

I am just constructing the gcc common test environments under a new PC,
is a PC also enough for KVM/Xen common test?

Welcome any ideas, suggestions or completions about it (especially the
information about KVM/Xen common test).


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
