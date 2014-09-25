Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaIYRmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:42:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:48969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaIYRmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:42:38 -0400
Message-ID: <54245409.5000306@infradead.org>
Date: Thu, 25 Sep 2014 10:42:33 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org
CC: linux-doc@vger.kernel.org, sudeep.dutt@intel.com, nikhil.rao@intel.com,
        ashutosh.dixit@intel.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] Make Documenation depend on headers_install
References: <1411612233-23025-1-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1411612233-23025-1-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 19:30, Peter Foley wrote:
> Cc: rdunlap@infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: sudeep.dutt@intel.com
> Cc: nikhil.rao@intel.com
> Cc: ashutosh.dixit@intel.com
> Cc: akpm@linux-foundation.org
> Cc: gregkh@linuxfoundation.org
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Applied.  Thanks.

> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 16a4d48..b3cf4f9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1579,6 +1579,8 @@ endif
>  	$(cmd_crmodverdir)
>  	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
>  	$(build)=$(build-dir)
> +# Make sure the latest headers are built for Documentation
> +Documentation/: headers_install
>  %/: prepare scripts FORCE
>  	$(cmd_crmodverdir)
>  	$(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
> 


-- 
~Randy
