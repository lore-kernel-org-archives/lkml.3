Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3JIOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:47:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40820 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3JIOrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:47:45 -0400
Date: Wed, 9 Oct 2013 15:47:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] kobject: show debug info on delayed kobject release
Message-ID: <20131009144718.GK25034@n2100.arm.linux.org.uk>
References: <20131008020918.GA1220@localhost> <20131008021452.GA6456@localhost> <CA+55aFwrovZf-LYa=_SyMNvqQkTfxREm0YuzDk8wJy+Krs0xzw@mail.gmail.com> <20131008031152.GA8218@localhost> <20131008121742.GA29280@localhost> <20131008221417.GF25034@n2100.arm.linux.org.uk> <20131008224840.GA15303@kroah.com> <CA+55aFzdABn=TiBbM0fdok1xO3UY7hUjXA8q7rUrg2dHCsN=Ng@mail.gmail.com> <20131009011833.GA14579@redhat.com> <20131009012621.GA7126@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009012621.GA7126@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 09:26:21AM +0800, Fengguang Wu wrote:
> Useful for locating buggy drivers on kernel oops.
> 
> It may add dozens of new lines to boot dmesg. DEBUG_KOBJECT_RELEASE is
> hopefully only enabled in debug kernels (like maybe the Fedora rawhide
> one, or at developers), so being a bit more verbose is likely ok.
> 
> CC: Russell King - ARM Linux <linux@arm.linux.org.uk>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
