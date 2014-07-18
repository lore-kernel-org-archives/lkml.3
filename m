Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761612AbaGRL6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:58:54 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:4821 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756347AbaGRL6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:58:53 -0400
Date: Fri, 18 Jul 2014 07:58:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Nick Krause <xerofoify@gmail.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Henderson <rth@twiddle.net>, ink@jurassic.park.msu.ru,
        Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: Alpha Checkpatch Errors
Message-ID: <20140718115847.GA23985@home.goodmis.org>
References: <CAPDOMVgJx4NTSDXyS4k9jfWzSw_vJ=TFDBPdCUgxa-Xato1bYA@mail.gmail.com>
 <alpine.DEB.2.10.1407180013260.24854@nanos>
 <CAPDOMViHhE22ndcjez+vfZWGprsx_Cw0Rn-FpaoNsi63cRnr9g@mail.gmail.com>
 <1405653693.21735.9.camel@buesod1.americas.hpqcorp.net>
 <CAPDOMVh-gtvTP6OY_fM31NcM_ez==f1fBNgV_YaoSXuQcUtiRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMVh-gtvTP6OY_fM31NcM_ez==f1fBNgV_YaoSXuQcUtiRQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 11:24:45PM -0400, Nick Krause wrote:
> >
> Yes I am human. Now thinking about it we need it to test for staging.

Why do you say that?

-- Steve

