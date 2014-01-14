Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaANAGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:06:30 -0500
Received: from www.sr71.net ([198.145.64.142]:45197 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaANAG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:06:28 -0500
Message-ID: <52D47F2A.6030609@sr71.net>
Date: Mon, 13 Jan 2014 16:04:58 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, bp@suse.de, dtor@vmware.com,
        kys@microsoft.com, haiyangz@microsoft.com, agraf@suse.de,
        gleb@redhat.com
Subject: Re: [PATCH 11/12] x86 Kconfig: create x86/Kconfig.virt
References: <20140113192245.3F682C7F@viggo.jf.intel.com> <20140113192259.5E9DFB02@viggo.jf.intel.com> <52D46CBB.9080103@redhat.com> <52D47020.6050306@sr71.net> <52D472ED.3050303@redhat.com>
In-Reply-To: <52D472ED.3050303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 03:12 PM, Paolo Bonzini wrote:
> Il 14/01/2014 00:00, Dave Hansen ha scritto:
>>>>         --- Virtualization                                                                          
>>>>         <*>   Kernel-based Virtual Machine (KVM) support                                            
>>>>         <*>     KVM for Intel processors support                                                    
>>>>         <*>     KVM for AMD processors support
>>>>         [*]     Audit KVM MMU                                                                       
>>>>         [*]     KVM legacy PCI device assignment support                                            
>>>>         < >   Host kernel accelerator for virtio net
>>>>         [*]   Linux guest support  --->
> 
> I think this is as confusing as before, perhaps worse because it is not
> clear that Linux guest support is not limited to KVM.

The "Linux guest support" menu is preexisting.  This patch just moves it
verbatim from "Processor type and features" to "Virtualization".  My
logic is that "Linux guest support" has a heck of a lot more to do with
"Virtualization" than the processor.

> If you really
> want a Virtualization menu, you have to clearly separate the guest and host:
> 
>     --- Virtualization
>         Linux guest support  --->
>         Virtualization host support  --->
> 
> with KVM and vhost under the second item.

I think it's kinda silly to have folks chase through two levels of menus
when the submenus would have both fit on the screen anyway.  Let's save
the layers of nesting for when we have 150 items in a menu.

I'll have new patches out in a sec.
