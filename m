Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaIVG4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 02:56:20 -0400
Received: from ozlabs.org ([103.22.144.67]:53165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaIVG4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 02:56:18 -0400
Message-ID: <1411368977.16867.11.camel@concordia>
Subject: Re: [PATCH 0/2] powerpc: pci-ioda: Neatening
From: Michael Ellerman <mpe@ellerman.id.au>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, shangw@linux.vnet.ibm.com
Date: Mon, 22 Sep 2014 16:56:17 +1000
In-Reply-To: <cover.1411320262.git.joe@perches.com>
References: <cover.1411320262.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-21 at 10:55 -0700, Joe Perches wrote:
> printk calls should return void
> 
> Joe Perches (2):
>   powerpc: pci-ioda: Remove unnecessary return value from printk
>   powerpc: pci-ioda: Use a single function to emit logging messages

Patches look good to me.

Ben/Gavin, what do these macros give us over pr/dev_debug() ?

cheers


