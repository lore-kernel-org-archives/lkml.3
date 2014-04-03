Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbaDCXkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:40:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:51883 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753933AbaDCXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:40:21 -0400
Date: Thu, 3 Apr 2014 19:40:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403194018.7c67aec7@gandalf.local.home>
In-Reply-To: <533DED74.6050202@linux.intel.com>
References: <20140403021411.6236996f@gandalf.local.home>
	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
	<533D001A.5030802@linux.intel.com>
	<20140403094155.04cc00bc@gandalf.local.home>
	<533D6BE7.3020608@zytor.com>
	<20140403104721.5f6c32b6@gandalf.local.home>
	<20140403111711.5bed4ff7@gandalf.local.home>
	<533D7C4F.4010504@zytor.com>
	<533D7C93.7080105@zytor.com>
	<20140403113921.23dceb75@gandalf.local.home>
	<533D8516.1040803@zytor.com>
	<20140403121314.246b03a7@gandalf.local.home>
	<533DED74.6050202@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr 2014 07:23:32 +0800
"Li, Aubrey" <aubrey.li@linux.intel.com> wrote:

> Can you please send the dmi table out?

I already did as a gz attachment to H. Peter. You were on the Cc, did
you not receive it?

-- Steve
