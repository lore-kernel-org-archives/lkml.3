Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaB0D3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:29:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48945 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754701AbaB0D31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:29:27 -0500
Message-ID: <530EB103.5070406@zytor.com>
Date: Wed, 26 Feb 2014 19:29:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>, Joe Perches <joe@perches.com>
CC: linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
References: <530E6F76.1070605@zytor.com> <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin>
In-Reply-To: <20140227025845.GA25145@thin>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 06:58 PM, Josh Triplett wrote:
> On Wed, Feb 26, 2014 at 06:53:14PM -0800, Joe Perches wrote:
>> Allow an override to emit or not the sizeof(bool) warning
>> Add a description to the manpage.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 

I have to admit that this particular warning is a bit odd to me.  I'm
wondering what kind of bugs it was intended to catch.

In particular, things that incorrectly assumes the size of bool to be
anything in particular would seem unlikely to actually use sizeof().

	-hpa


