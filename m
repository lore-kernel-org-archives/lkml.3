Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaGDEmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 00:42:08 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:36500 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaGDEmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 00:42:06 -0400
Message-ID: <1404448922.5756.67.camel@marge.simpson.net>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Austin Schuh <austin@peloton-tech.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 04 Jul 2014 06:42:02 +0200
In-Reply-To: <CANGgnMYq+QHaic1pRugDbudDAd8985KxSoUKRTbfnhwrZ5zSBQ@mail.gmail.com>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
	 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
	 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
	 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
	 <alpine.DEB.2.10.1406270027300.5170@nanos>
	 <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
	 <alpine.DEB.2.10.1406271249510.5170@nanos>
	 <CANGgnMZ8qemTgzoiq96=YvTnz-h945b8zSw1VtmDMSrbY3kcUg@mail.gmail.com>
	 <CANGgnMZBXbBnr1J+HDtDTo3TD-KgjerLA7BH9x6tmsdDfrNWbA@mail.gmail.com>
	 <CANGgnMYq+QHaic1pRugDbudDAd8985KxSoUKRTbfnhwrZ5zSBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-03 at 16:08 -0700, Austin Schuh wrote: 
> On Tue, Jul 1, 2014 at 12:32 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> > On Mon, Jun 30, 2014 at 8:01 PM, Austin Schuh <austin@peloton-tech.com> wrote:
> >> On Fri, Jun 27, 2014 at 7:24 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>> Completely untested patch below.
> 
> I've tested it and looked it over now, and feel pretty confident in
> the patch.  Thanks Thomas!

FWIW, I flogged my boxen hard with the virgin tglx patch applied again
after merging 3.14-rt5 with 3.14.10.  It remained thoroughly boring.

-Mike

