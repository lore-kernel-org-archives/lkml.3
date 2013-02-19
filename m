Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab3BSIr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:47:57 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:40494 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441Ab3BSIr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:47:56 -0500
Message-ID: <51233C36.4020804@gmail.com>
Date: Tue, 19 Feb 2013 03:47:50 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiederm@xmission.com, xemul@parallels.com, hpa@zytor.com,
        akpm@linux-foundation.org, Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
References: <20130219064800.719149796@openvz.org> <20130219065210.030802820@openvz.org>
In-Reply-To: <20130219065210.030802820@openvz.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2/19/13 1:48 AM), Cyrill Gorcunov wrote:
> Since kcmp syscall has been implemented (initially on
> x86 architecture) a number of other archs wire it up
> as well: xtensa, sparc, sh, s390, mips, microblaze,
> m68k (not taking into account those who uses
> <asm-generic/unistd.h> for syscall numbers
> definitions).
> 
> But the Makefile, which turns kcmp.o generation on
> still depends on former config-x86. Thus get rid
> of this limitation and make kcmp.o depend on CONFIG_KCMP
> option.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



