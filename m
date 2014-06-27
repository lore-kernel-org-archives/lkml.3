Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaF0L3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:29:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40372 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbaF0L3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:29:36 -0400
Message-ID: <53AD5597.50205@gmail.com>
Date: Fri, 27 Jun 2014 13:29:27 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: mtk.manpages@gmail.com, David Laight <David.Laight@aculab.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?ISO-8859-1?Q?Ondrej_B=EDlka?= <neleai@seznam.cz>,
        Caitlin Bestler <caitlin.bestler@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Elie De Brauwer <eliedebrauwer@gmail.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <steve@chygwyn.com>,
        =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= 
	<remi.denis-courmont@nokia.com>,
        Paul Moore <paul@paul-moore.com>,
        Chris Friesen <chris.friesen@windriver.com>
Subject: Re: [PATCH/RFC] Re: recvmmsg() timeout behavior strangeness [RESEND]
References: <20140527203010.GA2764@kernel.org> <5385D47A.3070401@gmail.com> <20140528150720.GB2764@kernel.org> <063D6719AE5E284EB5DD2968C1650D6D1724F2A0@AcuExch.aculab.com> <20140528195004.GD2764@kernel.org> <063D6719AE5E284EB5DD2968C1650D6D1724FB67@AcuExch.aculab.com> <20140529135547.GG2764@kernel.org> <063D6719AE5E284EB5DD2968C1650D6D1724FC78@AcuExch.aculab.com> <20140529141705.GI2764@kernel.org> <CAKgNAkj-MVfeqEeffWKMNok0yO-Rm1kyY+zhXEy-U9NkB+aLow@mail.gmail.com> <20140624202541.GD3456@kernel.org>
In-Reply-To: <20140624202541.GD3456@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 10:25 PM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jun 16, 2014 at 11:58:51AM +0200, Michael Kerrisk (man-pages) escreveu:
>> Hi Arnaldo,
>>
>> Things have gone quiet ;-). What's the current state of this patch?
> 
> Yeah, I kept meaning to prod the other people on this thread about what
> they thought about my last messages, patches, etc. :-)
> 
> Can I have acked-by or even tested-by on those? Is it ok?

I just need to go back and test one point that sounds like it might still be 
broken.

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
