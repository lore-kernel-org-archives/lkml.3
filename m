Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab3HTVn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:43:28 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:47129 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:43:25 -0400
Date: Wed, 21 Aug 2013 01:43:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -mm] docs: Document soft dirty behaviour for freshly
 created memory regions
Message-ID: <20130820214318.GP18673@moon>
References: <20130820153132.GK18673@moon>
 <1377033353.2737.80@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377033353.2737.80@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:15:53PM -0500, Rob Landley wrote:
> On 08/20/2013 10:31:32 AM, Cyrill Gorcunov wrote:
> >Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> >Cc: Pavel Emelyanov <xemul@parallels.com>
> >Cc: Andy Lutomirski <luto@amacapital.net>
> >Cc: Andrew Morton <akpm@linux-foundation.org>
> >Cc: Matt Mackall <mpm@selenic.com>
> >Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >Cc: Marcelo Tosatti <mtosatti@redhat.com>
> >Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> >Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> With that cc: list, I'll assume you do _not_ want the Documentation
> maintainer paying attention to it.

Hmm, I must admit I don't know whis else list should be CC'ed.
