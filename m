Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbaEMPd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:33:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:35785 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbaEMPds convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:33:48 -0400
Date: Tue, 13 May 2014 17:33:45 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.14.3-rt5
Message-ID: <20140513153345.GC15049@linutronix.de>
References: <20140509181214.GK29014@linutronix.de>
 <536D5CAA.9050100@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <536D5CAA.9050100@pavlinux.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Vasilyev | 2014-05-10 02:54:34 [+0400]:

>09.05.2014 22:12, Sebastian Andrzej Siewior пишет:
>
>>The delta patch against v3.14.3-rt4 is appended below and can be found
>
>Where delta from 3 to 4 ?
I can remeber answering that question to an earlier release. The change
is mostly in
    https://git.kernel.org/cgit/linux/kernel/git/bigeasy/rt-devel.git/commit/?id=be0f124e477586b437108e09b66153be66dad29d

For more details feel free to "git diff v3.14.2-rt3..v3.14.3-rt4" in
that tree. This is however just a stable fixup.

Sebastian
