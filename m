Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbaGOLPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:15:47 -0400
Received: from sym2.noone.org ([178.63.92.236]:37255 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758321AbaGOLPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:15:44 -0400
Date: Tue, 15 Jul 2014 13:15:42 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 00/29] nios2 Linux kernel port
Message-ID: <20140715111541.GG7668@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <20140715090813.GE7668@distanz.ch>
 <CAFiDJ5-YNB_uctBYFGkoABHfnwhuncy2FGrQk1j0qPVZBDrC3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFiDJ5-YNB_uctBYFGkoABHfnwhuncy2FGrQk1j0qPVZBDrC3g@mail.gmail.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ley Foon

On 2014-07-15 at 11:38:36 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> On Tue, Jul 15, 2014 at 5:08 PM, Tobias Klauser <tklauser@distanz.ch> wrote:
> >
> > On 2014-07-15 at 10:45:27 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> 
> >
> > Very nice work Ley Foon! It's great to see the Nios II port finally
> > making it upstream.
> >
> > I'll test the series on the NEEK and my custom board some time this
> > week.
> 
> FYI, you need new compiler that support generic ABI syscall. But, this
> new compiler is not public available yet.
> Will let you know once it is available.

Ah, thanks for the notice. Is it still possible to use the old syscall
ABI as a replacement on top of this series and use the current toolchain
from Mentor Graphics?

Thanks
Tobias
