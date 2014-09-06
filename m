Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663AbaIFPQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:16:33 -0400
Received: from dd17628.kasserver.com ([85.13.138.83]:53559 "EHLO
	dd17628.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaIFPQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:16:31 -0400
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2014 11:16:31 EDT
From: Milian Wolff <mail@milianw.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrien BAK <adrien.bak@numscale.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf tools : adds support for native scripting
Date: Sat, 06 Sep 2014 17:06:07 +0200
Message-ID: <141010294.FOuOkOaNci@minime>
User-Agent: KMail/4.14 (Linux/3.16.1-1-ARCH; KDE/4.14.0; x86_64; ; )
In-Reply-To: <871tvmqco4.fsf@tassilo.jf.intel.com>
References: <1400727182.19852.0.camel@desktop> <871tvmqco4.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014 04:24:11 Andi Kleen wrote:
> Adrien BAK <adrien.bak@numscale.com> writes:
> > As it is perf-script allows one to use perl or python scripts to parse
> > perf events.
> > The following proposal aimed to introduce support of .so files as scripts.
> > This support allows for better performance when parsing perf's data
> > files and a complete access to the raw data.
> 
> You'll at least need some documentation how to use it.

Ping, any news on this feature? I'd welcome the ability to create native 
scripts to write efficient tools based on perf.

Bye
-- 
Milian Wolff
mail@milianw.de
http://milianw.de
