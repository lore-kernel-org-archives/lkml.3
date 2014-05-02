Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaEBPwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaEBPwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:52:38 -0400
Message-ID: <5363BF42.9020505@redhat.com>
Date: Fri, 02 May 2014 17:52:34 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hu Yaohui <loki2441@gmail.com>
CC: kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: KVM Nested L2 guest startup problems
References: <CAHqbYQv+ZekSRQBbdEdfo+pXrM4ErjVDcj1T4oxHSP8Tc+322A@mail.gmail.com>	<53636B1D.8030405@redhat.com> <CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
In-Reply-To: <CAHqbYQsTnJifwQMnhzaBEBYNpN9aHaZ4Vr0GhNkQZuN+o2vNtA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2014 17:17, Hu Yaohui ha scritto:
> Hi Paolo,
> I have tried L0 with linux kernel 3.14.2 and L1 with linux kernel 3.14.2
> L1 QEMU qemu-1.7.0
> L2 QEMU qemu-1.7.0.

Do you mean L0 and L1?

What is your QEMU command line, and what is the processor?  Also, what 
guest you are running?

Paolo

> I still get the same error when running qemu in L1 guest.

