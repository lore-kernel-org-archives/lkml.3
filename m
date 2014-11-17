Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaKQJYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:24:07 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36955 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaKQJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:24:04 -0500
Message-ID: <5469BEAF.9030707@redhat.com>
Date: Mon, 17 Nov 2014 10:23:59 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
CC: imammedo@redhat.com
Subject: Re: [PATCH 0/3] KVM: simplification to the memslots code
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com> <546955BF.6020104@lab.ntt.co.jp>
In-Reply-To: <546955BF.6020104@lab.ntt.co.jp>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17/11/2014 02:56, Takuya Yoshikawa wrote:
>> > here are a few small patches that simplify __kvm_set_memory_region
>> > and associated code.  Can you please review them?
> Ah, already queued.  Sorry for being late to respond.

While they are not in kvm/next, there's time to add Reviewed-by's and
all that.  kvm/queue basically means "I want Fengguang to compile-test
them, some testing done on x86_64".

Paolo
