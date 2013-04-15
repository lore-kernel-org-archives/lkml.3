Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3DOK0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:26:36 -0400
Received: from ozlabs.org ([203.10.76.45]:56712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab3DOK0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:26:35 -0400
Date: Mon, 15 Apr 2013 20:26:31 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, acme@redhat.com, sukadev@linux.vnet.ibm.com,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/perf: Power8 PMU support
Message-ID: <20130415102630.GA2478@concordia>
References: <1365999438-20578-1-git-send-email-michael@ellerman.id.au>
 <1366011086.24994.33.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366011086.24994.33.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 09:31:26AM +0200, Benjamin Herrenschmidt wrote:
> On Mon, 2013-04-15 at 14:17 +1000, Michael Ellerman wrote:
> > This patch adds preliminary support for the power8 PMU to perf.
> 
> Might be worthwhile to have a small blurb explaining roughly what you
> mean by "preliminary" :-)

True.

There's no alternative handling, and no cache events. I need to work
with the HW folks on both of those.

Also missing is EBB support. I will hopefully post that in the next few
days.

cheers
