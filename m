Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab3KKVSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:18:37 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39084 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3KKVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:18:28 -0500
Date: Mon, 11 Nov 2013 22:18:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, sebastien.dugue@bull.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131111211825.GB19316@gmail.com>
References: <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
 <20131106155445.GB6357@neilslaptop.think-freely.org>
 <1383758363.7940.19.camel@joe-AO722>
 <20131108190136.GB16052@hmsreliant.think-freely.org>
 <1383939193.2639.39.camel@joe-AO722>
 <20131108201459.GE16052@hmsreliant.think-freely.org>
 <1383942547.2639.49.camel@joe-AO722>
 <20131111194020.GB6355@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111194020.GB6355@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Neil Horman <nhorman@tuxdriver.com> wrote:

> Ingo, does that seem reasonable to you?

FYI, in the past few days I've been busy due to the merge window, but 
everything I've seen so far in this portion of the thread gave me warm 
fuzzy feelings, so I definitely like the direction.

(More once I get around to looking at the code in detail.)

Thanks,

	Ingo
