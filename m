Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3GXWem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:34:42 -0400
Received: from ozlabs.org ([203.10.76.45]:41476 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3GXWel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:34:41 -0400
Date: Thu, 25 Jul 2013 08:34:27 +1000
From: Anton Blanchard <anton@samba.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
Message-ID: <20130725083427.56e36010@kryten>
In-Reply-To: <1374274770.5357.33@snotra>
References: <20130718140045.6794ecd5@kryten>
	<1374274770.5357.33@snotra>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Scott,

> I'm not really sure what it's supposed to look like when "perf  
> annotate" works.  It spits a bunch of unreadable[1]
> dark-blue-on-black assembly code at me, all with "0.00 :" in the left
> column.
> 
> Oh, wait -- some lines have "100.00 : " on the left, in  
> even-more-unreadable dark-red-on-black.
> 
> Apart from the annoying colors, is there anything specific I should
> be looking for?  Some sort of error message, or output that actually
> makes sense?

Thanks for testing! Ben, I think the patch is good to go.

Anton
