Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3KLIoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 03:44:34 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50854 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3KLIob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 03:44:31 -0500
Message-ID: <5281EA5F.3080604@biophys.uni-duesseldorf.de>
Date: Tue, 12 Nov 2013 21:44:15 +1300
From: schmitz <schmitz@biophys.uni-duesseldorf.de>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
References: <20130917082838.218329307@infradead.org> <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg> <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com> <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de> <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de> <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com> <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311112031220.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de> <55642d365fc4272c4f43a88ea435e360@biophys.uni-duesseldorf.de>
In-Reply-To: <55642d365fc4272c4f43a88ea435e360@biophys.uni-duesseldorf.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,
>
>>
>> If you look at the probability of the first two checks catching
>> anything, then it's pretty low. Most interrupts returns go through
>> ret_from_exception. Yes, I added counters which prove that at least on
>> the aranym, but I doubt that it will make a real difference if you run
>> this on real hardware.
>
> I'm happy to try that (indeed, verify your patch works on Atari 
> hardware first) - I trust the patch is relative to m68k git, not your 
> previous patches?

Pleased to report the patch works, as expected, on the actual hardware. 
I doubt we still need to profile the interrupt return path, Geert?

Cheers,

    Michael

