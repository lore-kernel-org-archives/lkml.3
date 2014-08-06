Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaHFJep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 05:34:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754768AbaHFJeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 05:34:44 -0400
Message-ID: <53E1F6B2.90201@suse.cz>
Date: Wed, 06 Aug 2014 11:34:42 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Himangi Saraogi <himangi774@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coccinelle: Script to replace if and BUG with BUG_ON
References: <20140720213635.GA12365@himangi-Dell> <53E0E9D0.9040500@suse.cz> <alpine.DEB.2.02.1408052015440.2047@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1408052015440.2047@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-05 20:16, Julia Lawall wrote:
> 
> 
> On Tue, 5 Aug 2014, Michal Marek wrote:
> 
>> On 2014-07-20 23:36, Himangi Saraogi wrote:
>>> This script detects cases where BUG() follows an if condition on an
>>> expression and replaces the if condition and BUG() with a BUG_ON having
>>> the conditional expression of the if statement as argument.
>>>
>>> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
>>> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
>>
>> Is this a result of some internal review, or where does Julia's Acked-by
>> come from? I'm just wondering, because I haven't seen any previous
>> version of this patch.
> 
> She sent it to me first.  It's OK with me.

OK, thanks for confirming. I'm going to merge this and the previous
patches by Himangi.

Michal
