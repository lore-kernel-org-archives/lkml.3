Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3LaT2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:28:41 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:52914 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab3LaT2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:28:39 -0500
Message-ID: <52C31AE4.1050501@lwfinger.net>
Date: Tue, 31 Dec 2013 13:28:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question on compiler warning
References: <52C21CE3.3020402@lwfinger.net> <52C2A2E5.3020100@ilande.co.uk>
In-Reply-To: <52C2A2E5.3020100@ilande.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 04:56 AM, Mark Cave-Ayland wrote:
> Hi Larry,
>
> Could it be that you don't see the issue the locally because you've got
> different compiler optimisation settings? I've seen a similar bug recently on
> another project where the "may be used uninitialized" warning appears with -O0
> and -O1 but magically disappears with the default -O2 setting (presumably
> because the optimiser performs some kind of inlining/reordering that makes the
> issue go away).

Mark,

It is possible. Certainly, a higher optimization level will force the compiler 
to do a better job of flow analysis. I am using -O2, which is the standard in 
the kernel makefile. I would expect that Geert is also using the same lever, but 
perhaps not.

Larry


