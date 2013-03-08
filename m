Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934147Ab3CHOdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:33:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55683 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab3CHOdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:33:02 -0500
Date: Fri, 8 Mar 2013 15:32:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/33] nohz: Basic full dynticks interface
Message-ID: <20130308143254.GE10714@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Alessio Igor Bogani <abogani@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Metcalf <cmetcalf@tilera.com>,
	Christoph Lameter <cl@linux.com>,
	Geoff Levand <geoff@infradead.org>,
	Gilad Ben Yossef <gilad@benyossef.com>,
	Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
	Li Zhong <zhong@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
 <1357610913-1080-8-git-send-email-fweisbec@gmail.com>
 <20130211143529.GB2749@pd.tnic>
 <CAFTL4hx1BzTtYSBp8zP+E1DNwgtErJJHN_aqagbss8SCryZBYg@mail.gmail.com>
 <20130308101731.GB10714@pd.tnic>
 <CAFTL4hzVwmRopLVso1cb+E+YT1rX25xeV1VLpC+0uxVcEQbExQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFTL4hzVwmRopLVso1cb+E+YT1rX25xeV1VLpC+0uxVcEQbExQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:45:12PM +0100, Frederic Weisbecker wrote:
> 2013/3/8 Borislav Petkov <bp@alien8.de>:
> > On Fri, Mar 08, 2013 at 12:35:47AM +0100, Frederic Weisbecker wrote:
> >> I think that "Full dynticks system" would express well what happens?
> >
> > Yeah, it probably doesn't really matter all that much in the end -
> > people will refer to this with different names like with other features
> > in Linux anyway. :-)
> 
> Right, with some more or less precision, and different shades of
> metaphor or metonymy :)
> 
> Dynticks, tickless, nohz, cpu isolation, pendulum clock noise free
> kernel, bare metal performance snort, walking alone and free through
> Latvian forests.

"... completely naked." You definitely need that too. :-)

Ok, put all those above in the Kconfig help text and ship it - people
will *now* know what it is.

LOL.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
