Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FZSt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:49:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40454 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZSt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:49:26 -0400
Message-ID: <51CB379A.7010606@infradead.org>
Date: Wed, 26 Jun 2013 11:48:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: linux-next: Tree for Jun 26 (xen/x86)
References: <20130626180653.57aee1721b4b5096ddc8f82d@canb.auug.org.au>
In-Reply-To: <20130626180653.57aee1721b4b5096ddc8f82d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/13 01:06, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130625:
> 

CONFIG_SMP is not set
CONFIG_X86_UP_APIC is not set

on i386:

drivers/built-in.o: In function `xen_callback_vector':
(.text+0x1dc3cb): undefined reference to `first_system_vector'
drivers/built-in.o: In function `xen_callback_vector':
(.text+0x1dc3f5): undefined reference to `first_system_vector'


-- 
~Randy
