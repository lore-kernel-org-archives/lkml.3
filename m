Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbaGPBVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:21:21 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:33355 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbaGPBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:21:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140715111541.GG7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<20140715090813.GE7668@distanz.ch>
	<CAFiDJ5-YNB_uctBYFGkoABHfnwhuncy2FGrQk1j0qPVZBDrC3g@mail.gmail.com>
	<20140715111541.GG7668@distanz.ch>
Date: Wed, 16 Jul 2014 09:21:18 +0800
X-Google-Sender-Auth: hFC35F5W3EM1VtBS4DF_TRcAxcI
Message-ID: <CAFiDJ59f0p3MF=ffH-Qk8Xx3w=sC-XqVMgeHKiQzcQ1=P=X+Xw@mail.gmail.com>
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 7:15 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> Hi Ley Foon

>
> Ah, thanks for the notice. Is it still possible to use the old syscall
> ABI as a replacement on top of this series and use the current toolchain
> from Mentor Graphics?
Hi Tobias

There are other changes in the nios2 kernel that requires new compiler.
So, old syscall ABI replacement most probably won't work.

Regards
Ley Foon
