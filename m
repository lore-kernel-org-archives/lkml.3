Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaFZJAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:00:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56048 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbaFZJAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:00:13 -0400
From: "Javi Merino" <javi.merino@arm.com>
Date: Thu, 26 Jun 2014 10:00:09 +0100
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update Eduardo Valentin's email address
Message-ID: <20140626090009.GB2825@e104805>
References: <1401444208-6887-1-git-send-email-lee.jones@linaro.org>
 <20140602172800.GA5902@developer>
MIME-Version: 1.0
In-Reply-To: <20140602172800.GA5902@developer>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 26 Jun 2014 09:00:00.0550 (UTC) FILETIME=[02E25460:01CF911D]
X-MC-Unique: 114062610001106801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:28:00PM +0100, Eduardo Valentin wrote:
> Hello Lee Jones,
> 
> On Fri, May 30, 2014 at 11:03:28AM +0100, Lee Jones wrote:
> > Eduardo TI address is bouncing, but it looks like he's still
> > contributing via his Gmail address.
> > 
> 
> Thanks for being proactive! I actually sent the very same patch a while
> ago:
> 
> 
> https://lkml.org/lkml/2014/4/2/644
> 
> 
> Maybe it's fallen into the cracks.
> 
> Rui, any idea what is the status of that patch?

I've been bitten by this *again*.  This patch should've been in
3.15-rc1, it's 3.16-rc2 and Eduardo's email is still outdated in the
MAINTAINERS file.  The thermal tree seems to be pretty stale lately
and patches are rotting in the list, but this update should really get
into the kernel ASAP.

Eduardo, can you send this to trivial@kernel.org ?

