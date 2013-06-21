Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161483Ab3FUHtC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:49:02 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35308 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab3FUHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130621071239.GM5523@atomide.com>
References: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au>
	<20130621164149.598b39bb78b6015057d03f6f@canb.auug.org.au>
	<20130621065310.GK5523@atomide.com>
	<CAOesGMjszju75jo6Ej6C=0-rfdPLuEj0mwmU1zYvFvYw1dyQCA@mail.gmail.com>
	<20130621071239.GM5523@atomide.com>
Date: Fri, 21 Jun 2013 13:18:59 +0530
Message-ID: <CAJe_Zhcbi8+S5wejzy4DCzL+VnD62J5N0nWdkCEDAWdfUAQ6_g@mail.gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the mailbox tree
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Olof Johansson <olof@lixom.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Loic Pallardy <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Suman Anna <s-anna@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 June 2013 12:42, Tony Lindgren <tony@atomide.com> wrote:
>
> Arnd pulled in tags/omap-for-v3.11/mailbox-signed, which is the branch
> that should get merged to the mainline tree while we're waiting for
> the generic mailbox framework from Jassi.
>
FYKI I, Suman and Loic have been co-ordinating offline. The generic
framework is almost there, Suman recently did the omap porting too,
Loic seems to be caught up with some other stuff. Lately we have been
joined by another developer LF.Tan to write the driver for a
not-yet-public IP.

cheers.
