Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaGOPCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:02:44 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40775 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaGOPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:02:42 -0400
Message-ID: <53C5428E.5050400@twiddle.net>
Date: Tue, 15 Jul 2014 08:02:38 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>
CC: Jakub Jelinek <jakub@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Miroslav Franc <mfranc@redhat.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Dan <opendtv@yahoo.com>
Subject: Re: bit fields && data tearing
References: <20140712181328.GA8738@redhat.com>	 <20140712205130.GA16437@redhat.com> <1405208082.20996.54.camel@pasglop>	 <53C2865B.5040200@hurleysoftware.com> <1405290324.20996.71.camel@pasglop> <53C53288.0@hurleysoftware.com>
In-Reply-To: <53C53288.0@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 06:54 AM, Peter Hurley wrote:
> 
> Jonathan Corbet wrote a LWN article about this back in 2012:
> http://lwn.net/Articles/478657/
> 
> I guess it's fixed in gcc 4.8, but too bad there's not a workaround for
> earlier compilers (akin to -fstrict_volatile_bitfields without requiring
> the volatile keyword)

>From the gcc pr, it looks like the patch was backported to 4.7.
But we didn't fix it in versions earlier than that.


r~
