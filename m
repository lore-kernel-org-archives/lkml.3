Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaGCFVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:21:16 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:40548 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaGCFVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <CABg9mcsWia-RW9QfSKeiUeTrDJ_cr-gPY7QTmsFWradyB+1Uxg@mail.gmail.com>
References: <1404278424-31176-1-git-send-email-zlim.lnx@gmail.com>
	<CAMEtUuy8Dxzcn1svphvxVEGwSL1yvMuDN8uQC_4d-h3Cw33TfQ@mail.gmail.com>
	<CABg9mcsWia-RW9QfSKeiUeTrDJ_cr-gPY7QTmsFWradyB+1Uxg@mail.gmail.com>
Date: Wed, 2 Jul 2014 22:21:14 -0700
Message-ID: <CABg9mcv9_bhx3OwJZHuQhy7Bim2E+VOYwfevHDn+jQ4O1ZN+dA@mail.gmail.com>
Subject: Re: [PATCH RFC] arm64: eBPF JIT compiler
From: Z Lim <zlim.lnx@gmail.com>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 9:57 PM, Z Lim <zlim.lnx@gmail.com> wrote:
> On Wed, Jul 2, 2014 at 2:28 PM, Alexei Starovoitov <ast@plumgrid.com> wrote:
>> On Tue, Jul 1, 2014 at 10:20 PM, Zi Shen Lim <zlim.lnx@gmail.com> wrote:
>> Do you really need 'jump by register' then? Regular 'bl' would be much faster.
>
> We'll need BLR to cover all cases. BL instruction can only address
> +/-128MB (28-bits).
>
> BTW, what is the range of "imm" for JMP|CALL? I'm guessing since it's
> s32, so +/-512MB?

Oops... I meant: is it +/-2GB?
