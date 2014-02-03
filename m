Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaBCNgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:36:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42752 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaBCNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:36:36 -0500
Date: Mon, 3 Feb 2014 13:36:30 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/27] 3.12.9-stable review
Message-ID: <20140203133630.GA5258@hercules>
References: <20140123190648.720195687@linuxfoundation.org>
 <20140124193950.GA21365@hpx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140124193950.GA21365@hpx.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:39:50PM +0100, Radim Krčmář wrote:
> Hello,
> 
> could 3.12.9 and 3.10.28 include
>   0dce7cd kvm: x86: fix apic_base enable check
> ?  It fixes a regression applied to 3.10.26 and 3.12.7.

I am also queuing this for the 3.11 kernel.  Thanks!

Cheers,
--
Luis


> Stable was mentioned on kvm-list[1], but it might have been forgotten.
> More information is in bugzilla[2].
> 
> Thanks.
> 
> 
> ---
> 1: http://www.spinics.net/lists/kvm/msg99343.html
> 2: https://bugzilla.redhat.com/show_bug.cgi?id=1055872
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
