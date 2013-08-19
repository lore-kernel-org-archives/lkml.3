Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab3HSVKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:10:17 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37821 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3HSVKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:10:14 -0400
Date: Tue, 20 Aug 2013 01:10:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Track vma changes with VM_SOFTDIRTY bit
Message-ID: <20130819211006.GA18673@moon>
References: <20130819195836.GO23919@moon>
 <20130819140816.6c35952c0bc19c480a9664d6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819140816.6c35952c0bc19c480a9664d6@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 02:08:16PM -0700, Andrew Morton wrote:
> > 
> > Thus when user space application track memory changes
> > now it can detect if vma area is renewed.
> 
> Can we please update Documentation/vm/soft-dirty.txt for this?

Oops. Sorry, forgot about soft-dirty.txt. Sure I'll update it
later tonight or tomorrow, thanks!
