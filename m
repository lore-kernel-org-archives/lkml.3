Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbaLDVPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:15:34 -0500
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:39840 "EHLO
	resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933119AbaLDVP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:15:29 -0500
Date: Thu, 4 Dec 2014 15:15:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Leonard Crestez <lcrestez@ixiacom.com>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
In-Reply-To: <20141204205202.GP29748@ZenIV.linux.org.uk>
Message-ID: <alpine.DEB.2.11.1412041514250.14832@gentwo.org>
References: <547E3E57.3040908@ixiacom.com> <20141204175713.GE2995@htj.dyndns.org> <5480BFAA.2020106@ixiacom.com> <alpine.DEB.2.11.1412041426230.14577@gentwo.org> <20141204205202.GP29748@ZenIV.linux.org.uk>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014, Al Viro wrote:

> ... except that somebody has not known that and took refcounts on e.g.
> vfsmounts into percpu.  With massive amounts of hilarity once docker folks
> started to test the workloads that created/destroyed those in large amounts.

Well, vfsmounts being a performance issue is a bit weird and unexpected.

