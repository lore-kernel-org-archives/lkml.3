Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113AbaKYS6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:58:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35987 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaKYS6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:58:07 -0500
Date: Tue, 25 Nov 2014 19:58:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST
 context
Message-ID: <20141125185803.GC3938@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUFwyBYFWZi4JC1-HftmUumLr+bB1kh8EW6LViN+G+j+g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 03:52:10PM -0800, Andy Lutomirski wrote:
> Dunno. Tony and Borislav -- when do you want the IST stack switching
> stuff?

I'd leave that up to Tony and his testbench. I mean, we can hammer on
it as much as we can and it can pass all testing locally but the real
fun starts once it hits upstream and for that it doesn't matter which
release... IMHO.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
