Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaDQRq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:46:28 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:60143 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDQRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:46:22 -0400
Date: Thu, 17 Apr 2014 10:46:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140417174615.GO4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161007080.9945@gentwo.org>
 <20140416160621.GX4496@linux.vnet.ibm.com>
 <20140416171230.GA8788@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
 <20140416184755.GY4496@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404171235480.28251@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404171235480.28251@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041717-7164-0000-0000-0000011D3263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:36:06PM -0500, Christoph Lameter wrote:
> On Wed, 16 Apr 2014, Paul E. McKenney wrote:
> 
> > Queued, thank you.  I don't need this until 3.16, but I am tempted
> > to push it in this cycle in case others need it.  Any objections?
> 
> No its a bug fix.

Fair enough!  I resent the patch with your Ack to Tejun.

							Thanx, Paul

