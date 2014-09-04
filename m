Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaIERHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:07:04 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:42353 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbaIERHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:07:03 -0400
Date: Thu, 4 Sep 2014 13:21:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: dynticks: Remove atomic ops for dynticks_idle
In-Reply-To: <20140904161834.GG5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409041320040.14314@gentwo.org>
References: <alpine.DEB.2.11.1409041016410.4565@gentwo.org> <20140904161834.GG5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Paul E. McKenney wrote:

> On Thu, Sep 04, 2014 at 10:18:31AM -0500, Christoph Lameter wrote:
> > This is on top of the first patch (but still not against your tree). I
> > wonder what you think about this one. No special operations.
> >
> >
> > Since dynticks_idle is only ever modified by the local cpu we do
> > not need to use atomics there.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Sorry, as discussed earlier, this change is non-trivial.  In addition,
> you have not justified the change.

The rationale is quite clear: Use of atomics without the need to use them.

