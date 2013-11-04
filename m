Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3KDTJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 14:09:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49110 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KDTI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 14:08:58 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20131104174841.GA19498@gmail.com>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org> <20131103101825.GA6605@gmail.com> <20131103102132.GA6807@gmail.com> <20131103155729.GB9944@hansolo.jdub.homelinux.org> <20131104065343.GC13030@gmail.com> <20131104140141.GC9944@hansolo.jdub.homelinux.org> <20131104141051.GA19355@gmail.com> <20131104141615.GD9944@hansolo.jdub.homelinux.org> <20131104155624.GA31656@sgi.com> <20131104174841.GA19498@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 04 Nov 2013 11:08:38 -0800
To: Ingo Molnar <mingo@kernel.org>, Russ Anderson <rja@sgi.com>
CC: Josh Boyer <jwboyer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <ec38985e-ab71-464a-9565-e56b99d34a05@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8192 maybe?

Ingo Molnar <mingo@kernel.org> wrote:
>
>* Russ Anderson <rja@sgi.com> wrote:
>
>> > Russ, does SGI (or anyone else that you know of) have x86 hardware 
>> > with more than 4096 CPUs?
>> 
>> Yes.  We have a system in the lab with 254 12-core IVB sockets for a 
>> total of 3048 cores.  With HT is it 6096 cpus.
>
>It would then be nice to up MAXSMP to 6144 or so.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
