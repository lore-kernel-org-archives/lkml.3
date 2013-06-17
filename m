Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3FQP0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:26:13 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:53573 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3FQP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:26:11 -0400
Message-ID: <51BF2A8C.5020903@redhat.com>
Date: Mon, 17 Jun 2013 17:26:04 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/2] kvm/mips: ABI fix for 3.10
References: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1370892828-21676-1-git-send-email-ddaney.cavm@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 10/06/2013 21:33, David Daney ha scritto:
> From: David Daney <david.daney@cavium.com>
> 
> As requested by Gleb Natapov, we need to define and use KVM_REG_MIPS
> when using the GET_ONE_REG/SET_ONE_REG ioctl.  Since this is part of
> the MIPS kvm support that is new in 3.10, it should be merged before a
> bad ABI leaks out into an 'official' kernel release.
> 
> David Daney (2):
>   kvm: Add definition of KVM_REG_MIPS
>   mips/kvm: Use KVM_REG_MIPS and proper size indicators for *_ONE_REG
> 
>  arch/mips/include/uapi/asm/kvm.h | 81 +++++++++++++++++++--------------------
>  arch/mips/kvm/kvm_mips.c         | 83 ++++++++++++++++++++++++++--------------
>  include/uapi/linux/kvm.h         |  1 +
>  3 files changed, 94 insertions(+), 71 deletions(-)
> 

CCed people probably already know, but anyway: this is already in
Linus's tree (commit af180b81a3f4ea925fae88878f367e676e99bf73).

Paolo
