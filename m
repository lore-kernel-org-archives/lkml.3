Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3BRV6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 16:58:21 -0500
Received: from ja.ssi.bg ([178.16.129.10]:37843 "EHLO ja.ssi.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756402Ab3BRV6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 16:58:20 -0500
Date: Mon, 18 Feb 2013 23:57:46 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
        Simon Horman <horms@verge.net.au>, Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: fix functions and variables related to
 netns_ipvs->sysctl_sync_qlen_max
In-Reply-To: <5121C699.2050408@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1302182253560.1723@ja.ssi.bg>
References: <51131B88.6040809@cn.fujitsu.com> <51132A56.60906@cn.fujitsu.com> <alpine.LFD.2.00.1302070944480.1810@ja.ssi.bg> <20130214142159.d0516a5f.akpm@linux-foundation.org> <alpine.LFD.2.00.1302152304010.1746@ja.ssi.bg>
 <5121C699.2050408@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811672-176011512-1361224671=:1723"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-176011512-1361224671=:1723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Mon, 18 Feb 2013, Zhang Yanfei wrote:

> 于 2013年02月16日 05:39, Julian Anastasov 写道:
> > 
> > 	Hello,
> > 
> > On Thu, 14 Feb 2013, Andrew Morton wrote:
> > 
> >> Redarding this patch:
> >> net-change-type-of-netns_ipvs-sysctl_sync_qlen_max.patch and
> >> net-fix-functions-and-variables-related-to-netns_ipvs-sysctl_sync_qlen_max.patch
> >> are joined at the hip and should be redone as a single patch with a
> >> suitable changelog, please.  And with a cc:netdev@vger.kernel.org.
> > 
> > 	Agreed, Zhang Yanfei and Simon? I'm just not sure,
> > may be this combined patch should hit only the
> > ipvs->nf->net trees? Or may be net-next, if we don't have
> > time for 3.8.
> > 
> 
> Should I resend the combined patch?

	Yes, please! Just add CC: netdev@vger.kernel.org.
Simon will take the patch for the networking trees.

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-176011512-1361224671=:1723--
