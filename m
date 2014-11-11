Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaKKTkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:40:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:52352 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaKKTkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:40:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,362,1413270000"; 
   d="scan'208";a="606127708"
Message-ID: <1415734800.21508.0.camel@theros.lm.intel.com>
Subject: Re: [PATCH 3/6] x86: Add support for the clwb instruction
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        x86@kernel.org
Date: Tue, 11 Nov 2014 12:40:00 -0700
In-Reply-To: <20141111191904.GA12555@pd.tnic>
References: <1415731396-19364-1-git-send-email-ross.zwisler@linux.intel.com>
	 <1415731396-19364-4-git-send-email-ross.zwisler@linux.intel.com>
	 <20141111191239.GC31523@pd.tnic> <20141111191904.GA12555@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20.rez) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 20:19 +0100, Borislav Petkov wrote:
> On Tue, Nov 11, 2014 at 08:12:39PM +0100, Borislav Petkov wrote:
> > > +			 ".byte 0x66; xsaveopt %P0",
> > 
> > Huh, XSAVEOPT?!? Shouldn't that be CLWB??
> 
> Bah, the same opcodes, only 0x66 prefix makes it into CLWB. Could use a
> comment I guess.

Yep, it's weird, I know.  :)  I'll add a comment.

Thanks,
- Ross

