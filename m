Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3HVGFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:05:08 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:42152 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab3HVGFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:05:06 -0400
Date: Thu, 22 Aug 2013 08:05:03 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/padata.c: always check the return value of
 __padata_remove_cpu() and __padata_add_cpu()
Message-ID: <20130822060503.GC26773@secunet.com>
References: <5212E5E4.8010408@asianux.com>
 <5212E61F.7010602@asianux.com>
 <20130822051122.GB26773@secunet.com>
 <5215A134.90607@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215A134.90607@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 22 Aug 2013 06:05:03.0760 (UTC) FILETIME=[8B144900:01CE9EFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 01:27:16PM +0800, Chen Gang wrote:
> On 08/22/2013 01:11 PM, Steffen Klassert wrote:
> > On Tue, Aug 20, 2013 at 11:44:31AM +0800, Chen Gang wrote:
> >>
> >> If this patch is correct, better to let CPU_ONLINE and CPU_DOWN_FAILED
> >> share the same code.
> >>
> >> And do we need a comment "/* fall through */" between CPU_UP_CANCELED
> >> and CPU_DOWN_FAILED (or it is another bug, need a 'break' statement) ?
> >>
> >> At last, also better to let CPU_DOWN_PREPARE and CPU_UP_CANCELED share
> >> the same code (if need a 'break'), or share the most of code (if "fall
> >> through").
> >>
> > 
> > CPU_ONLINE and CPU_DOWN_FAILED can share the code. Same is true for
> > CPU_DOWN_PREPARE and CPU_UP_CANCELED.
> > 
> > Thanks!
> > 
> > 
> 
> Thank you too.
> 
> And need I send another patch for it ?
> 
> Or just make by yourself (and better to mark me as Reported-by). :-)
> 

You found the problem, feel free to send a patch.
