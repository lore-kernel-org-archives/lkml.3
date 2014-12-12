Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967057AbaLLUqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:46:49 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37794 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056AbaLLUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:46:46 -0500
Date: Fri, 12 Dec 2014 12:46:42 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: hpa@zytor.com, josh@joshtriplett.org, sam@ravnborg.org, bpoirier@suse.de,
        x86@kernel.org, kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Borislav Petkov <bp@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 2/2] x86, arm, platform, xen, kconfig: add xen defconfig
 helper
In-Reply-To: <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com>
Message-ID: <alpine.DEB.2.10.1412121246250.2273@chino.kir.corp.google.com>
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com> <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2014, Luis R. Rodriguez wrote:

> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This lets you build a kernel which can support xen dom0
> or xen guests by just using:
> 
>    make xenconfig
> 
> on both x86 and arm64 kernels. This also splits out the
> options which are available currently to be built with x86
> and 'make ARCH=arm64' under a shared config.
> 
> Technically xen supports a dom0 kernel and also a guest
> kernel configuration but upon review with the xen team
> since we don't have many dom0 options its best to just
> combine these two into one.
> 
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: penberg@kernel.org
> Cc: levinsasha928@gmail.com
> Cc: mtosatti@redhat.com
> Cc: fengguang.wu@intel.com
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Ian Campbell <Ian.Campbell@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xenproject.org
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Acked-by: David Rientjes <rientjes@google.com>
