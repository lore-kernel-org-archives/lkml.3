Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbaLKAWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:22:18 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40634 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbaLKAWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:22:16 -0500
MIME-Version: 1.0
In-Reply-To: <20141125185803.GC3938@pd.tnic>
References: <20141124205441.GW5050@linux.vnet.ibm.com>
	<CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
	<20141124213501.GX5050@linux.vnet.ibm.com>
	<20141124223407.GB8512@linux.vnet.ibm.com>
	<CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
	<20141124225754.GY5050@linux.vnet.ibm.com>
	<20141124233101.GA2819@linux.vnet.ibm.com>
	<CALCETrV37kqC658AzBHZ5z_vH2b_1T821q5EfbMcS9Ecpj8EEw@mail.gmail.com>
	<20141124235058.GZ5050@linux.vnet.ibm.com>
	<CALCETrUFwyBYFWZi4JC1-HftmUumLr+bB1kh8EW6LViN+G+j+g@mail.gmail.com>
	<20141125185803.GC3938@pd.tnic>
Date: Wed, 10 Dec 2014 16:22:15 -0800
Message-ID: <CA+8MBb+iw3KJz5EgX-DLBHGWANUSVFP2bQe2_U4kqCfM-wzH8Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:58 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Nov 24, 2014 at 03:52:10PM -0800, Andy Lutomirski wrote:
>> Dunno. Tony and Borislav -- when do you want the IST stack switching
>> stuff?
>
> I'd leave that up to Tony and his testbench. I mean, we can hammer on
> it as much as we can and it can pass all testing locally but the real
> fun starts once it hits upstream and for that it doesn't matter which
> release... IMHO.

So what was the net result of all the mode/RCU discussions?

Do I need some extra magic incantations in the final version
of do_machine_check() beyond what was in this patch:

  https://lkml.kernel.org/r/546d169211835aded@agluck-desk.sc.intel.com

to make everything happy?

-Tony
