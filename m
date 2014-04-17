Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaDQRgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:36:19 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:46217
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbaDQRgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:36:09 -0400
Date: Thu, 17 Apr 2014 12:36:06 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
In-Reply-To: <20140416184755.GY4496@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1404171235480.28251@gentwo.org>
References: <20140415221755.GA27188@linux.vnet.ibm.com> <alpine.DEB.2.10.1404161007080.9945@gentwo.org> <20140416160621.GX4496@linux.vnet.ibm.com> <20140416171230.GA8788@linux.vnet.ibm.com> <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
 <20140416184755.GY4496@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Paul E. McKenney wrote:

> Queued, thank you.  I don't need this until 3.16, but I am tempted
> to push it in this cycle in case others need it.  Any objections?

No its a bug fix.
