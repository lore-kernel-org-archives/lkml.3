Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaLJAlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 19:41:13 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45706 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaLJAlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 19:41:11 -0500
X-Originating-IP: 50.43.43.148
Date: Tue, 9 Dec 2014 16:40:55 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: hpa@zytor.com, sam@ravnborg.org, bpoirier@suse.de, x86@kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Borislav Petkov <bp@suse.de>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>, levinsasha928@gmail.com,
        mtosatti@redhat.com, fengguang.wu@intel.com,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 1/2] x86, platform, xen, kconfig: clarify kvmconfig is
 for kvm
Message-ID: <20141210004054.GA3073@thin>
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com>
 <1418168138-6425-2-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418168138-6425-2-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 03:35:37PM -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> We'll be adding options for xen as well.
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
> Acked-by: David Rientjes <rientjes@google.com>
> Acked-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  scripts/kconfig/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 9645c07..ff612b0 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -141,7 +141,7 @@ help:
>  	@echo  '  randconfig	  - New config with random answer to all options'
>  	@echo  '  listnewconfig   - List new options'
>  	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
> -	@echo  '  kvmconfig	  - Enable additional options for guest kernel support'
> +	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
>  	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
>  
>  # lxdialog stuff
> -- 
> 2.1.1
> 
