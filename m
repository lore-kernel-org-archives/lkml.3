Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaFZJTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:19:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:24082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaFZJTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,552,1400050800"; 
   d="scan'208";a="563758078"
Message-ID: <1403774367.16305.76.camel@rzhang1-toshiba>
Subject: Re: [PATCH] MAINTAINERS: Update Eduardo Valentin's email address
From: Zhang Rui <rui.zhang@intel.com>
To: Javi Merino <javi.merino@arm.com>
Cc: Eduardo Valentin <edubezval@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Thu, 26 Jun 2014 17:19:27 +0800
In-Reply-To: <20140626090009.GB2825@e104805>
References: <1401444208-6887-1-git-send-email-lee.jones@linaro.org>
	 <20140602172800.GA5902@developer> <20140626090009.GB2825@e104805>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 10:00 +0100, Javi Merino wrote:
> On Mon, Jun 02, 2014 at 06:28:00PM +0100, Eduardo Valentin wrote:
> > Hello Lee Jones,
> > 
> > On Fri, May 30, 2014 at 11:03:28AM +0100, Lee Jones wrote:
> > > Eduardo TI address is bouncing, but it looks like he's still
> > > contributing via his Gmail address.
> > > 
> > 
> > Thanks for being proactive! I actually sent the very same patch a while
> > ago:
> > 
> > 
> > https://lkml.org/lkml/2014/4/2/644
> > 
> > 
> > Maybe it's fallen into the cracks.
> > 
> > Rui, any idea what is the status of that patch?
> 

Oops, sorry for the late response.
I thought all the patches that touches MAINTAINER file should go to
Linus directly, thus I did not take a patch in the beginning.

Patch applied and queued for 3.16-rc4.

thanks,
rui
> I've been bitten by this *again*.  This patch should've been in
> 3.15-rc1, it's 3.16-rc2 and Eduardo's email is still outdated in the
> MAINTAINERS file.  The thermal tree seems to be pretty stale lately
> and patches are rotting in the list, but this update should really get
> into the kernel ASAP.
> 
> Eduardo, can you send this to trivial@kernel.org ?
> 


