Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaB0EUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:20:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49330 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaB0EUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:20:19 -0500
Message-ID: <530EBCED.9020705@zytor.com>
Date: Wed, 26 Feb 2014 20:19:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Pfaff <blp@nicira.com>, Joe Perches <joe@perches.com>
CC: Christopher Li <sparse@chrisli.org>, Josh Triplett <josh@joshtriplett.org>,
        linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
References: <530E6F76.1070605@zytor.com> <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com> <1393466619.24588.65.camel@joe-AO722> <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com> <1393472326.24588.82.camel@joe-AO722> <20140227040050.GA8449@nicira.com>
In-Reply-To: <20140227040050.GA8449@nicira.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 08:00 PM, Ben Pfaff wrote:
> 
> The commit *relaxed* sparse behavior: because previously sizeof(bool)
> was an error.  I'm not in favor of any diagnostic at all for
> sizeof(bool), but my recollection is that a sparse maintainer wanted it
> to yield one.
> 

Still not clear as to why.

	-hpa


