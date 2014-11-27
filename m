Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbaK0PMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:12:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45357 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbaK0PMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:12:45 -0500
X-Sasl-enc: CEfPyiFZWvyt/Zm4d+15fSSR4rJadZxPOJz0Aj2Nrb+A 1417101162
Date: Thu, 27 Nov 2014 07:11:20 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>,
        Benjamin Romer <benjamin.romer@unisys.com>
Subject: Re: linux-next: manual merge of the staging tree with the kbuild tree
Message-ID: <20141127151120.GA16919@kroah.com>
References: <20141127190508.3305dfe8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127190508.3305dfe8@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:05:08PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict
> in .gitignore between commit dfe0487249e5 (".gitignore: Add Kdevelop4
> project files") from the kbuild tree and commit 75185f57f110 ("staging:
> unisys: fix CamelCase macro names in controlframework.h") from the
> staging tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc .gitignore
> index ce57b79670a5,6bfac06d79ca..000000000000
> --- a/.gitignore
> +++ b/.gitignore
> @@@ -97,5 -97,6 +97,9 @@@ x509.genke
>   # Kconfig presets
>   all.config
>   
>  +# Kdevelop4
>  +*.kdev4
> ++
> + #eclipse files
> + .project
> + .cproject


Woah, I missed that this patch in the staging tree added to the
.gitignore file, that's not ok, sorry about that, I'll go rip this patch
out of my tree.

Benjamin, please be more careful.

greg k-h
