Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaCXRjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:39:47 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36284 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbaCXRjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:39:44 -0400
Message-ID: <53306DD8.8020002@redhat.com>
Date: Mon, 24 Mar 2014 18:39:36 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Stefan Bader <stefan.bader@canonical.com>
CC: Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FCFA23.4060701@canonical.com> <20140213173852.GH6835@laptop.programming.kicks-ass.net> <52FD090C.7010408@canonical.com> <20140213182605.GC14089@laptop.programming.kicks-ass.net> <20140214133428.GB26356@pd.tnic> <52FE2709.3050505@canonical.com> <20140214144700.GC26356@pd.tnic> <52FE4C28.1080500@canonical.com> <20140214172157.GJ6835@laptop.programming.kicks-ass.net> <53062165.3040202@canonical.com> <20140220155041.GG9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140220155041.GG9987@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/02/2014 16:50, Peter Zijlstra ha scritto:
>>>> > >> One thing I likely should do is to reinstall the exact same laptop with 64bit
>>>> > >> kernel and userspace... maybe only 64bit kernel first... and make sure on my
>>>> > >> side that this does not show up on 64bit, too. I took the word of reporters for
>>>> > >> that (and the impression that otherwise many more people would have complained).
>>> > >
>>> > > Yeha, I'm going to try and install some 32bit userspace on a usb
>>> > > harddisk I've got and see if I can boot my Core2 laptop from that to try
>>> > > and reproduce.
>>> > >
>>> > > But all that is probably going to be Monday :/
>>> > >
>> > *sigh* Already Thursday...
>> >
>> > Peter, did you get to reproduce this locally? Unfortunately I had some
>> > interruption and have not more Information than on last Friday (which is that
>> > the same hw but 64bit kernel does not show it).
> I got side-tracked as well, someone reported crashes, which come above
> weird behaviour :/
>

Stefan, Peter, any news here?

Paolo
