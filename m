Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3DMN27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:28:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48772 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3DMN25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:28:57 -0400
Date: Sat, 13 Apr 2013 06:28:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH PART2 v4 6/6] staging: ramster: add how-to for ramster
Message-ID: <20130413132854.GA28650@kroah.com>
References: <1365858092-21920-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1365858092-21920-7-git-send-email-liwanp@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365858092-21920-7-git-send-email-liwanp@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 09:01:32PM +0800, Wanpeng Li wrote:
> Add how-to for ramster.
> 
> Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Singed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/ramster/HOWTO.txt |  257 ++++++++++++++++++++++++++++++
>  1 file changed, 257 insertions(+)
>  create mode 100644 drivers/staging/zcache/ramster/HOWTO.txt
> 
> diff --git a/drivers/staging/zcache/ramster/HOWTO.txt b/drivers/staging/zcache/ramster/HOWTO.txt
> new file mode 100644
> index 0000000..a4ee979
> --- /dev/null
> +++ b/drivers/staging/zcache/ramster/HOWTO.txt
> @@ -0,0 +1,257 @@
> +Version: 130309
> + Dan Magenheimer <dan.magenheimer@oracle.com>

If Dan wrote this, why are you listing yourself as the author of this
patch?

> +CHANGELOG:
> +v5-120214->120817: updated for merge into new zcache codebase
> +v4-120126->v5-120214: updated for V5
> +111227->v4-120126: added info on selfshrinking and rebooting
> +111227->v4-120126: added more info for tracking RAMster stats
> +111227->v4-120126: CONFIG_PREEMPT_NONE no longer necessary
> +111227->v4-120126: cleancache now works completely so no need to disable it

That is not needed in an in-kernel file, please remove it.

greg k-h
