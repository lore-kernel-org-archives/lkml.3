Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaDDPO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 11:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbaDDPOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:14:23 -0400
Message-ID: <533ECC2C.6090505@zytor.com>
Date: Fri, 04 Apr 2014 08:13:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>,
        "Li, Aubrey" <aubrey.li@linux.intel.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
References: <533D7C4F.4010504@zytor.com> <533D7C93.7080105@zytor.com> <20140403113921.23dceb75@gandalf.local.home> <533D8516.1040803@zytor.com> <20140403121314.246b03a7@gandalf.local.home> <533DED74.6050202@linux.intel.com> <20140403194018.7c67aec7@gandalf.local.home> <533DF455.4040908@linux.intel.com> <533DF8D2.9060508@zytor.com> <533E0A94.5040007@linux.intel.com> <20140404151203.GA12370@srcf.ucam.org>
In-Reply-To: <20140404151203.GA12370@srcf.ucam.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 08:12 AM, Matthew Garrett wrote:
> On Fri, Apr 04, 2014 at 09:27:48AM +0800, Li, Aubrey wrote:
> 
>> The current situation is,
>> - we have one(do we know more?) preproduction machine hangs by CF9.
>> - We have more than one(could be thousand known) production machine
>> works by CF9.
> 
> Production hardware should never require CF9.
> 

There are a lot of things that shouldn't be.

	-hpa

