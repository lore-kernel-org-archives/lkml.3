Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaDDRCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:02:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50444 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbaDDRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:02:36 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <cbb97256-9323-4d67-8523-061972e07ecc@email.android.com>
References: <20140403113921.23dceb75@gandalf.local.home> <533D8516.1040803@zytor.com> <20140403121314.246b03a7@gandalf.local.home> <533DED74.6050202@linux.intel.com> <20140403194018.7c67aec7@gandalf.local.home> <533DF455.4040908@linux.intel.com> <533DF8D2.9060508@zytor.com> <533E0A94.5040007@linux.intel.com> <20140404151203.GA12370@srcf.ucam.org> <CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com> <20140404154520.GA14980@srcf.ucam.org> <533EDE6A.1050804@zytor.com> <cbb97256-9323-4d67-8523-061972e07ecc@email.android.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [BUG] x86: reboot doesn't reboot
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 04 Apr 2014 10:01:54 -0700
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <bc180094-55f6-426b-a8a8-f77efc581045@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's not what you said a few posts ago.

On April 4, 2014 9:32:58 AM PDT, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>Windows does ACPI first, so no. And the Dells were broken even before
>we moved ACPI up the list. 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
