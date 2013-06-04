Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3FDLdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:33:22 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:43611 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3FDLdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:33:20 -0400
MIME-Version: 1.0
X-Originating-IP: [87.114.94.91]
In-Reply-To: <20130604090508.GL4725@redhat.com>
References: <1369222162-4857-1-git-send-email-james.hogan@imgtec.com>
	<20130604090508.GL4725@redhat.com>
Date: Tue, 4 Jun 2013 12:33:19 +0100
X-Google-Sender-Auth: _A7DexaH4nDjI_8Qm6zZ0uOQuUE
Message-ID: <CAAG0J98B=TiJXkrK2dF8DaWQjoHwkk+k7CXiN1XJ5VHQFkowFA@mail.gmail.com>
Subject: Re: [PATCH 1/1] KVM: add kvm_para_available to asm-generic/kvm_para.h
From: James Hogan <james.hogan@imgtec.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 10:05, Gleb Natapov <gleb@redhat.com> wrote:
> On Wed, May 22, 2013 at 12:29:22PM +0100, James Hogan wrote:
>> According to include/uapi/linux/kvm_para.h architectures should define
>> kvm_para_available, so add an implementation to asm-generic/kvm_para.h
>> which just returns false.
>>
> What is this fixing? The only user of kvm_para_available() that can
> benefit from this is in sound/pci/intel8x0.c, but I do not see follow up
> patch to use it there.

It was an unintentional config with mips + kvm + intel8x0 that hit it
(I think I accidentally based my mips config off an x86_64 config).
Kind of equivalent to a randconfig build failure I suppose.

Cheers
James
