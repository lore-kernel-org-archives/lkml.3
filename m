Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaLDVUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:20:42 -0500
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:53179 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752997AbaLDVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:20:41 -0500
Date: Thu, 4 Dec 2014 15:20:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Leonard Crestez <lcrestez@ixiacom.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sorin Dumitru <sdumitru@ixiacom.com>
Subject: Re: [RFC v2] percpu: Add a separate function to merge free areas
In-Reply-To: <20141204211912.GG4080@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1412041520270.14925@gentwo.org>
References: <547E3E57.3040908@ixiacom.com> <20141204175713.GE2995@htj.dyndns.org> <5480BFAA.2020106@ixiacom.com> <alpine.DEB.2.11.1412041426230.14577@gentwo.org> <20141204205202.GP29748@ZenIV.linux.org.uk> <alpine.DEB.2.11.1412041514250.14832@gentwo.org>
 <20141204211912.GG4080@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Dec 2014, Tejun Heo wrote:

> Docker usage is pretty wide-spread now, making what used to be
> siberia-cold paths hot enough to cause actual scalability issues.
> Besides, we're now using percpu_ref for things like aio and cgroup
> control structures which can be created and destroyed quite
> frequently.  I don't think we can say these are "weird" use cases
> anymore.

Well then lets write a scalable percpu allocator.

