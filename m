Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaJBR1x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:27:53 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46339 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaJBR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:27:51 -0400
Date: Thu, 2 Oct 2014 20:28:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, akpm@linux-foundation.org, rui.xiang@huawei.com,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gorcunov@openvz.org,
        kirill.shutemov@linux.intel.com, grant.likely@secretlab.ca,
        tytso@mit.edu, Thierry Herbelot <thierry.herbelot@6wind.com>
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the
 directory entries
Message-ID: <20141002172814.GA2435@p183.telecom.by>
References: <20131003.150947.2179820478039260398.davem@davemloft.net>
 <1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
 <1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 05:25:01PM +0200, Nicolas Dichtel wrote:
> +static inline unsigned int proc_pde_name_hash(const unsigned char *name,
> +					      const unsigned int len)
> +{
> +	return full_name_hash(name, len) & PROC_PDE_HASH_MASK;
> +}

PDE already stands for "proc dir entry" :^)

	Alexey
