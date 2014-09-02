Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaIBUr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:47:59 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:46033
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140AbaIBUr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:47:58 -0400
Date: Tue, 2 Sep 2014 15:47:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140902203743.GL5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409021545370.32690@gentwo.org>
References: <alpine.DEB.2.11.1409021513490.26284@gentwo.org> <20140902203743.GL5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Paul E. McKenney wrote:

> But yes, in theory, something like this can work if appropriate memory
> barriers are put in place.  In practice, this sort of change needs
> profound testing on multiple architectures.

Ok how can we move forward? I just looked further and it seems a similar
approach could perhaps work for the dynticks field.

If the first patch I send gets merged then a lot of other this_cpu related
optimizations become possible regardless of the ones in the RFC.


