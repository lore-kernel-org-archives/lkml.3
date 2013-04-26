Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3DZMQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:16:23 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38701 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3DZMQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <20130426114622.GB3736@osiris>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
 <20130426112539.GA3736@osiris> <20130426114622.GB3736@osiris>
From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 26 Apr 2013 08:15:39 -0400
Message-ID: <CAKU6vyZ1QYTtwNahEb=aeTqym660-XBF20CYqVb8RXgsX93MeQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] seccomp filter JIT
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 7:46 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> And build fine on s390.

Thanks!

>> Btw. are there any test cases around for BPF JIT?
>> Not only for the new seccomp but also netfilter?
>
> This however is still a valid question.

Not sure about test cases for BPF JIT in general.  I used the examples
under "samples/seccomp/" for testing; they are seccomp filters though.

- xi
