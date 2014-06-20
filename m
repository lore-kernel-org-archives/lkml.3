Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaFTQHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:07:17 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:37532 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933940AbaFTQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:07:15 -0400
Date: Fri, 20 Jun 2014 11:07:13 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: josh@joshtriplett.org, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <20140620153839.GB4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406201106010.11238@gentwo.org>
References: <20140619014200.GO8178@tassilo.jf.intel.com> <alpine.DEB.2.11.1406190941180.2785@gentwo.org> <20140619180916.GE4904@linux.vnet.ibm.com> <alpine.DEB.2.11.1406191531020.4002@gentwo.org> <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org> <alpine.DEB.2.11.1406191614270.5484@gentwo.org> <20140619213203.GA16747@cloud> <20140619230732.GX4904@linux.vnet.ibm.com> <alpine.DEB.2.11.1406201019430.10810@gentwo.org>
 <20140620153839.GB4904@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Paul E. McKenney wrote:

> And the fraction of the small systems that care that much about latency
> is also quite small.

This also impacts general performance of course not only latency.

> Of course, if you have performance results that show otherwise, please
> share them.

We are discussing a performance problem right here.
