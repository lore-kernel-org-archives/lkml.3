Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966218AbaFRL4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:56:13 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33876 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933986AbaFRL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:56:11 -0400
Date: Wed, 18 Jun 2014 12:56:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Build error - vmlinux.lds [Re: linux-next: Tree for Jun 18]
Message-ID: <20140618115602.GA32514@n2100.arm.linux.org.uk>
References: <CAK5sBcEpXboRVD-KzzjBJMi+LF-jhdt_HUYEz7wkJtFAv+BLcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK5sBcEpXboRVD-KzzjBJMi+LF-jhdt_HUYEz7wkJtFAv+BLcg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:50:43PM +0530, Sachin Kamat wrote:
> Hi,
> 
> I observe the following build error while building uImage for ARM.
> 
>   Kernel: arch/arm/boot/Image is ready
> make[2]: *** No rule to make target
> `arch/arm/boot/compressed/vmlinux.lds', needed by
> `arch/arm/boot/compressed/vmlinux'.  Stop.
> make[1]: *** [arch/arm/boot/compressed/vmlinux] Error 2
> make: *** [uImage] Error 2

Works fine here against an empty object tree:

http://www.arm.linux.org.uk/developer/build/file.php?lid=9591

Are you building into an already-built object tree or rebuilding an
already built tree?

This is likely caused by make getting confused over the dependencies.
I suggest making clean to recover from this error.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
