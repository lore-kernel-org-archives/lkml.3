Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaDCPji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:39:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:13725 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752471AbaDCPjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:39:23 -0400
Date: Thu, 3 Apr 2014 11:39:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403113921.23dceb75@gandalf.local.home>
In-Reply-To: <533D7C93.7080105@zytor.com>
References: <20140403021411.6236996f@gandalf.local.home>
	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
	<533D001A.5030802@linux.intel.com>
	<20140403094155.04cc00bc@gandalf.local.home>
	<533D6BE7.3020608@zytor.com>
	<20140403104721.5f6c32b6@gandalf.local.home>
	<20140403111711.5bed4ff7@gandalf.local.home>
	<533D7C4F.4010504@zytor.com>
	<533D7C93.7080105@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/oSGbNQsOKnbGKrfaK6kUtio"
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/oSGbNQsOKnbGKrfaK6kUtio
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 03 Apr 2014 08:21:55 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 04/03/2014 08:20 AM, H. Peter Anvin wrote:
> > 
> > Also, can you send the dmidecode from your system?  Is it a Dell?

Hmm, I didn't see this email. Note, this box is an old development box
that Intel sent me years ago.

> > 
> 
> (And I assume you're booting BIOS, not EFI.)

Yeah, and I'm not sure it even has EFI. I'll have to hook a monitor to
it to find out. I rather not do that ;-)

-- Steve


--MP_/oSGbNQsOKnbGKrfaK6kUtio
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=dmidecode.gz

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
AA==

--MP_/oSGbNQsOKnbGKrfaK6kUtio--
