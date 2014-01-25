Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaAYAEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 19:04:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46194 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaAYAEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 19:04:34 -0500
Date: Fri, 24 Jan 2014 16:05:24 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/27] 3.12.9-stable review
Message-ID: <20140125000524.GA4606@kroah.com>
References: <20140123190648.720195687@linuxfoundation.org>
 <20140124193950.GA21365@hpx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140124193950.GA21365@hpx.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 08:39:50PM +0100, Radim Krčmář wrote:
> Hello,
> 
> could 3.12.9 and 3.10.28 include
>   0dce7cd kvm: x86: fix apic_base enable check
> ?  It fixes a regression applied to 3.10.26 and 3.12.7.

I'll queue it up for the next round of stable kernels, thanks.

> Stable was mentioned on kvm-list[1], but it might have been forgotten.

Yes, no one marked it for the stable tree :(

thanks,

greg k-h
