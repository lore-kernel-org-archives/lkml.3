Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab3DZSkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:40:11 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49498 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3DZSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:40:08 -0400
Message-ID: <1367001606.8964.246.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 11:40:06 -0700
In-Reply-To: <CAKU6vyYQ84o=W7=cqNFTcpBXmDn+CPE5g-66kUJsR_Kc8a9iZg@mail.gmail.com>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
	 <1366962706-24204-3-git-send-email-xi.wang@gmail.com>
	 <1366985926.8964.190.camel@edumazet-glaptop>
	 <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
	 <1366989094.8964.212.camel@edumazet-glaptop>
	 <CAKU6vyav+4e1RTKnpNRUJ64TO9AJWy2n2yY4rC-PKiqLei0rfw@mail.gmail.com>
	 <1366992840.8964.239.camel@edumazet-glaptop>
	 <CAKU6vyYQ84o=W7=cqNFTcpBXmDn+CPE5g-66kUJsR_Kc8a9iZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 14:25 -0400, Xi Wang wrote:
> Not sure how many you are speaking for when you say "We are very dumb".  :)
> 
> Thanks for catching this.  I'l remove this arch thing in v2.
> 
> To address your other concern about registers, I'll add some comments
> to the code, something like:
> 
> "%rdi,%r8,%r9 are not used by seccomp filters; it's safe to not save them."

OK good

BTW, most of us prefer Bottom posting on lkml/netdev

 http://en.wikipedia.org/wiki/Posting_style#Bottom-posting

Thanks


