Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaC2Uh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 16:37:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbaC2UhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 16:37:25 -0400
Message-ID: <53372F03.9010803@suse.cz>
Date: Sat, 29 Mar 2014 21:37:23 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Senna Tschudin <peter.senna@gmail.com>
CC: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cocci@systeme.lip6.fr" <cocci@systeme.lip6.fr>,
        Andreea Bernat <bernat.ada@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coccicheck: Remove memcpy to struct assignment test
References: <1395177092-3023-1-git-send-email-peter.senna@gmail.com> <1395230578.12633.21.camel@thorin> <CA+MoWDoSYu-aSp39vBe7DmayH2iqagHNYP9BC7LefajMXk+FnQ@mail.gmail.com> <1395237927.12633.29.camel@thorin> <20140319164855.GB27142@kroah.com>
In-Reply-To: <20140319164855.GB27142@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 19.3.2014 17:48, Greg Kroah-Hartman napsal(a):
>>>> On Die, 2014-03-18 at 22:11 +0100, Peter Senna Tschudin wrote:
>>>>> The Coccinelle script scripts/coccinelle/misc/memcpy-assign.cocci look
>>>>> for opportunities to replace a call to memcpy by a struct assignment.
>>>>> This patch removes memcpy-assign.cocci as it is not clear that this
>>>>> convention has an impact on the generated code.
[...]
> Can someone please just remove the check from the kernel as I'm getting
> tired of rejecting patches that do this...

I just applied Peter's revert to kbuild.git#misc.

Michal

