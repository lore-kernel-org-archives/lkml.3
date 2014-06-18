Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967382AbaFRO3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:29:23 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:51461 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966889AbaFRO3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:29:20 -0400
Date: Wed, 18 Jun 2014 09:29:17 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Andi Kleen <ak@linux.intel.com>
cc: Dave Hansen <dave.hansen@intel.com>, paulmck@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
In-Reply-To: <20140618001517.GL8178@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1406180929020.28208@gentwo.org>
References: <539B594C.8070004@intel.com> <20140613224519.GV4581@linux.vnet.ibm.com> <53A0CAE5.9000702@intel.com> <20140618001517.GL8178@tassilo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Andi Kleen wrote:

> I still think it's totally the wrong place. cond_resched() is in so
> many fast paths (every lock, every allocation). It just doesn't
> make sense to add non essential things like this to it.
>
> I would be rather to just revert the original patch.

I fully agree.

