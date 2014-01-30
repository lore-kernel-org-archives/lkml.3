Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaA3Xby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:31:54 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40907 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaA3Xbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:31:51 -0500
Date: Thu, 30 Jan 2014 15:31:44 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Roger Pau =?UTF-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Cc: <konrad.wilk@oracle.com>, <Xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V0] linux PVH: Set CR4 flags
Message-ID: <20140130153144.10d6f91e@mantra.us.oracle.com>
In-Reply-To: <52EA3A3C.4030209@citrix.com>
References: <1391040918-11722-1-git-send-email-mukesh.rathor@oracle.com>
	<52EA3A3C.4030209@citrix.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014 11:40:44 +0000
Roger Pau Monné <roger.pau@citrix.com> wrote:

> On 30/01/14 00:15, Mukesh Rathor wrote:
> > Konrad,
> > 
> > The CR4 settings were dropped from my earlier patch because you
> > didn't wanna enable them. But since you do now, we need to set them
> > in the APs also. If you decide not too again, please apply my prev
> > patch "pvh: disable pse feature for now".
> 
> Hello Mukesh,
> 
> Could you push your CR related patches to a git repo branch? I'm
> currently having a bit of a mess in figuring out which ones should be
> applied and in which order.
> 
> Thanks, Roger.

Hey Roger,

Unfortunately, I don't have them in a tree because my first patch was 
changed during merge, and also the tree was refreshed.  Basically, the end
result, we leave features enabled on linux side, thus setting not only
the cr0 bits, but also the cr4 PSE and PGE for APs (they were already
set for the BSP). 

Konrad only merged the CR0 setting part of my first patch, hence this 
patch to set the CR4 bits. Hope that makes sense. My latest tree is:

http://oss.us.oracle.com/git/mrathor/linux.git  muk2

thanks
mukesh
