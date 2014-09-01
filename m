Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaIAWqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:46:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaIAWqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:46:07 -0400
Message-ID: <5404F72D.8030402@suse.de>
Date: Tue, 02 Sep 2014 00:46:05 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
        linux-s390@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/2] KVM: minor cleanup and optimizations
References: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1409231583-7048-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28.08.14 15:13, Radim Krčmář wrote:
> The first patch answers a demand for inline arch functions.
> (There is a lot of constant functions that could be inlined as well.)
> 
> Second patch digs a bit into the history of KVM and removes a useless
> argument that seemed suspicious when preparing the first patch.
> 
> 
> Radim Krčmář (2):
>   KVM: static inline empty kvm_arch functions
>   KVM: remove garbage arg to *hardware_{en,dis}able

Acked-by: Alexander Graf <agraf@suse.de>


Alex
