Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3CHNpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:45:16 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33289 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab3CHNpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:45:14 -0500
MIME-Version: 1.0
In-Reply-To: <20130308101731.GB10714@pd.tnic>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	<1357610913-1080-8-git-send-email-fweisbec@gmail.com>
	<20130211143529.GB2749@pd.tnic>
	<CAFTL4hx1BzTtYSBp8zP+E1DNwgtErJJHN_aqagbss8SCryZBYg@mail.gmail.com>
	<20130308101731.GB10714@pd.tnic>
Date: Fri, 8 Mar 2013 14:45:12 +0100
Message-ID: <CAFTL4hzVwmRopLVso1cb+E+YT1rX25xeV1VLpC+0uxVcEQbExQ@mail.gmail.com>
Subject: Re: [PATCH 07/33] nohz: Basic full dynticks interface
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8 Borislav Petkov <bp@alien8.de>:
> On Fri, Mar 08, 2013 at 12:35:47AM +0100, Frederic Weisbecker wrote:
>> I think that "Full dynticks system" would express well what happens?
>
> Yeah, it probably doesn't really matter all that much in the end -
> people will refer to this with different names like with other features
> in Linux anyway. :-)

Right, with some more or less precision, and different shades of
metaphor or metonymy :)

Dynticks, tickless, nohz, cpu isolation, pendulum clock noise free
kernel, bare metal performance snort, walking alone and free through
Latvian forests.
