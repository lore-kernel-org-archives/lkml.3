Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab3GREAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 00:00:39 -0400
Received: from ozlabs.org ([203.10.76.45]:44380 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab3GREAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 00:00:38 -0400
Date: Thu, 18 Jul 2013 14:00:45 +1000
From: Anton Blanchard <anton@samba.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
Message-ID: <20130718140045.6794ecd5@kryten>
In-Reply-To: <1374019697.8183.351@snotra>
References: <1374014420.8183.342@snotra>
	<1374019445.19894.403.camel@pasglop>
	<1374019697.8183.351@snotra>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Scott,

> What specifically should I do to test it?

Could you double check perf annotate works? I'm 99% sure it will but
that is what was failing on ppc64.

Anton
