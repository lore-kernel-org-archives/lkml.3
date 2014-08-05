Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaHETt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaHETt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:27 -0400
From: Paul Moore <pmoore@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: linux-next: build warning after merge of the security tree
Date: Tue, 05 Aug 2014 15:49:17 -0400
Message-ID: <2473453.7vHnsXcYFU@sifl>
Organization: Red Hat
User-Agent: KMail/4.13.3 (Linux/3.15.7-gentoo; KDE/4.13.3; x86_64; ; )
In-Reply-To: <20140804162549.28c9889d@canb.auug.org.au>
References: <20140804162549.28c9889d@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 04, 2014 04:25:49 PM Stephen Rothwell wrote:
> Hi James,
> 
> After merging the security tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> In file included from include/net/cipso_ipv4.h:41:0,
>                  from net/ipv4/sysctl_net_ipv4.c:24:
> include/net/netlabel.h:527:12: warning: 'netlbl_catmap_setlong' defined but
> not used [-Wunused-function] static int netlbl_catmap_setlong(struct
> netlbl_lsm_catmap **catmap, ^
> 
> Introduced by commit 4b8feff251da ("netlabel: fix the horribly broken
> catmap functions").

Looks like I forgot to mark the dummy function as an inline, I'll get that 
fixed soon.

-- 
paul moore
security and virtualization @ redhat

