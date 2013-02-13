Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3BMTuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:50:00 -0500
Received: from slan-550-85.anhosting.com ([174.127.110.175]:10997 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756093Ab3BMTt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:49:59 -0500
Date: Wed, 13 Feb 2013 20:49:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>
Subject: Re: [PATCH nf-next] netfilter: nf_ct_reasm: fix per-netns sysctl
 initialization
Message-ID: <20130213194947.GA3805@localhost>
References: <20130213094810.64691C3A4E@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213094810.64691C3A4E@unicorn.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slan-550-85.anhosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 60rpm.tv
X-Get-Message-Sender-Via: slan-550-85.anhosting.com: authenticated_id: p@60rpm.tv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:46:09AM +0100, Michal Kubecek wrote:
> Adjusting of data pointers in net/netfilter/nf_conntrack_frag6_*
> sysctl table for other namespaces points to wrong netns_frags
> structure and has reversed order of entries.
> 
> Problem introduced by commit c038a767cd69 in 3.7-rc1

Applied, thanks Michal.
