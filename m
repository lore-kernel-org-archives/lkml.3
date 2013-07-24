Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab3GXXiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 19:38:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:60970 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3GXXiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 19:38:18 -0400
Message-ID: <1374707665.6142.18.camel@pasglop>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Anton Blanchard <anton@samba.org>
Cc: Scott Wood <scottwood@freescale.com>, Paul Mackerras <paulus@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 09:14:25 +1000
In-Reply-To: <20130725083427.56e36010@kryten>
References: <20130718140045.6794ecd5@kryten> <1374274770.5357.33@snotra>
	 <20130725083427.56e36010@kryten>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 08:34 +1000, Anton Blanchard wrote:
> > Apart from the annoying colors, is there anything specific I should
> > be looking for?  Some sort of error message, or output that actually
> > makes sense?
> 
> Thanks for testing! Ben, I think the patch is good to go.

Sent it yesterday to Linus, it's upstream already :-)

Cheers,
Ben.


