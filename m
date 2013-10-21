Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3JUNzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab3JUNy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:54:56 -0400
Date: Mon, 21 Oct 2013 09:54:38 -0400
From: Peter Jones <pjones@redhat.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.woodhouse@intel.com,
        ian.campbell@citrix.com, jbeulich@suse.com, keir@xen.org,
        konrad.wilk@oracle.com, richard.l.maliszewski@intel.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xen.org, grub-devel@gnu.org,
        linux-kernel@vger.kernel.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131021135437.GD1283@fenchurch.internal.datastacks.com>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 02:57:56PM +0200, Daniel Kiper wrote:
> Hi,
> 
> During work on multiboot2 protocol support for Xen it was discovered
> that memory map passed via relevant tag could not represent wide range
> of memory types available on EFI platforms. Additionally, GRUB2
> implementation calls ExitBootServices() on them just before jumping
> into loaded image. In this situation loaded system could not clearly
> identify reserved memory regions, EFI runtime services regions and others.

I think you'll find that many distros are shipping patches to grub2 to
add a "linuxefi" command that starts the kernel through its EFISTUB
code.  You may want to look in to that.

-- 
        Peter
