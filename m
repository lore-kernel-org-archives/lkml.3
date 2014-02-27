Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbaB0Rzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:55:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48291 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaB0Rzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:55:43 -0500
Date: Thu, 27 Feb 2014 12:55:38 -0500 (EST)
Message-Id: <20140227.125538.644682810852332446.davem@davemloft.net>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jwboyer@fedoraproject.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: 3.12-stable kernel tree being taken over by Jiri Slaby
From: David Miller <davem@davemloft.net>
In-Reply-To: <530EFA78.1020802@suse.cz>
References: <20140226231910.GA8789@kroah.com>
	<20140226.183927.1607497823277720839.davem@davemloft.net>
	<530EFA78.1020802@suse.cz>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2014 09:55:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>
Date: Thu, 27 Feb 2014 09:42:32 +0100

> On 02/27/2014 12:39 AM, David Miller wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Date: Wed, 26 Feb 2014 15:19:10 -0800
>> 
>>> David, I don't know if you want to keep doing 3.12-networking patches or
>>> not, I'll let you work that out with Jiri directly.
>> 
>> 3.12 and 3.13 are very similar, so the work is minimal, therefore I'm
>> likely to keep doing it.
> 
> Hi, do you have any plans including:
> commit 18fc25c94eadc52a42c025125af24657a93638c0
> Author: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> Date:   Mon Dec 2 15:41:39 2013 -0800
> 
>     rds: prevent BUG_ON triggered on congestion update to loopback
> 
> which is not needed for 3.13, but is needed for 3.12 to fix CVE-2012-2372?

Feel free to integrate this directly into your -stable tree.

Thanks.
