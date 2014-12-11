Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966021AbaLKVdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:33:37 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:51285 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965499AbaLKVde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:33:34 -0500
MIME-Version: 1.0
In-Reply-To: <20141211.153204.228153607927530694.davem@davemloft.net>
References: <20141125203310.8240.27370.stgit@ahduyck-server>
	<54892B87.3020909@gmail.com>
	<20141211.153204.228153607927530694.davem@davemloft.net>
Date: Thu, 11 Dec 2014 13:33:32 -0800
X-Google-Sender-Auth: CzAcmi6ncm1Z4szJRpr5UT5zpz0
Message-ID: <CA+55aFxE-zT9De8A-nwqtPiVn2ON19go76ui6buYskOU3L3a7g@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] arch: Add lightweight memory barriers for coherent
 memory access
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: Alexander Duyck <alexander.duyck@gmail.com>,
        Alexander Duyck <alexander.h.duyck@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        donald.c.skidmore@intel.com, matthew.vick@intel.com,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, nic_swsd@realtek.com,
        Will Deacon <will.deacon@arm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Tony Luck <tony.luck@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:32 PM, David Miller <davem@davemloft.net> wrote:
>
> I have no problem taking this via my tree, but I want to see agreement
> from other interested parties.

Since the early users are network drivers, and since it's otherwise
cross-architecture and not clear under any other maintainership, that
sounds good to me.

The arch parts were, I think, largely uncontroversial once naming and
a couple of small arch details were fixed up, so I don't think there's
any problem there.

                      Linus
