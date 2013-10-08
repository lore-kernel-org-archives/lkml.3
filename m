Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3JHQAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:00:53 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753226Ab3JHQAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:00:52 -0400
Message-ID: <52542C2D.7040800@nod.at>
Date: Tue, 08 Oct 2013 18:00:45 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, vgupta@synopsys.com, catalin.marinas@arm.com,
        will.deacon@arm.com, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        vapier@gentoo.org, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper.nilsson@axis.com, dhowells@redhat.com,
        rkuo@codeaurora.org, tony.luck@intel.com, fenghua.yu@intel.com,
        takata@linux-m32r.org, geert@linux-m68k.org, james.hogan@imgtec.com,
        monstr@monstr.eu, yasutake.koichi@jp.panasonic.com,
        ralf@linux-mips.org, jonas@southpole.se, jejb@parisc-linux.org,
        deller@gmx.de, benh@kernel.crashing.org, paulus@samba.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        liqin.linux@gmail.com, lennox.wu@gmail.com, lethal@linux-sh.org,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org
Subject: Re: [PATCH 27/29] get_signal_to_deliver: remove regs and cookie args
References: <1381232179-4385-1-git-send-email-richard@nod.at> <1381232179-4385-3-git-send-email-richard@nod.at> <20131008155252.GA14080@infradead.org>
In-Reply-To: <20131008155252.GA14080@infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.10.2013 17:52, schrieb Christoph Hellwig:
> On Tue, Oct 08, 2013 at 01:36:17PM +0200, Richard Weinberger wrote:
>> Both arguments are unused, remove them.
> 
> And with the get_signal macro left as the only caller, that one should
> become the implementation function.

Will do so.

Thanks,
//richard

