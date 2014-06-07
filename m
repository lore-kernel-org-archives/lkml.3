Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaFGJOQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 05:14:16 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:53175 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaFGJOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 05:14:14 -0400
Date: Sat, 7 Jun 2014 02:14:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Borislav Petkov <bp@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 3/3] x86, platform, kconfig: add virtconfig defconfig
 helper
In-Reply-To: <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
Message-ID: <alpine.DEB.2.02.1406070213240.12573@chino.kir.corp.google.com>
References: <1402096269-4512-1-git-send-email-mcgrof@do-not-panic.com> <1402096269-4512-3-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Luis R. Rodriguez wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This lets you use:
> 
>    make virtconfig
> 
> to merge you current kernel configuration with options to
> enable both kvm and xen (dom0 and guest) requirements.
> 

I'm not sure that this shortcut is worth a separate make target.
