Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaLWEJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:09:53 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:56615 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaLWEJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:09:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141223132605.02d81e01@canb.auug.org.au>
References: <20141208184908.27bfd605@canb.auug.org.au>
	<20141208103328.GE27367@arm.com>
	<20141223132605.02d81e01@canb.auug.org.au>
Date: Mon, 22 Dec 2014 20:09:50 -0800
X-Google-Sender-Auth: jtkXOgF_Wn19U5T8friXKFUPDjA
Message-ID: <CA+55aFwQKe0PvSuYqOeQMM8kouB3mkyQQ=gFMX=bkPx3GxanvA@mail.gmail.com>
Subject: Re: linux-next: missing merge fix patch for the merge of the xen-tip
 tree with the arm-soc tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Will Deacon <will.deacon@arm.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 6:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Linus,
>
> I have been carrying this merge fix patch for some time that is now
> needed in your tree:

No, it's not. Look more closely.

My merge put the

        dev->archdata.dma_coherent = coherent;

line at the top of the function, like the way it was in the original commit.

                            Linus
