Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935249AbaH1Gsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 02:48:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:58518 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533AbaH1Gsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 02:48:30 -0400
Date: Thu, 28 Aug 2014 08:48:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Travis <travis@sgi.com>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, msalter@redhat.com, dyoung@redhat.com, riel@redhat.com,
        peterz@infradead.org, mgorman@suse.de, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] x86: Speed up ioremap operations
Message-ID: <20140828064825.GA6059@gmail.com>
References: <20140827225927.364537333@asylum.americas.sgi.com>
 <20140827160610.4ef142d28fd7f276efd38a51@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827160610.4ef142d28fd7f276efd38a51@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 27 Aug 2014 17:59:27 -0500 Mike Travis <travis@sgi.com> wrote:
> 
> > 
> > We have a large university system in the UK that is experiencing
> > very long delays modprobing the driver for a specific I/O device.
> > The delay is from 8-10 minutes per device and there are 31 devices
> > in the system.  This 4 to 5 hour delay in starting up those I/O
> > devices is very much a burden on the customer.
> 
> That's nuts.

Agreed, and I'd suggest marking this for -stable, once it's all 
settled and tested.

Thanks,

	Ingo
