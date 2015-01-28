Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761279AbbA1Vsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:48:41 -0500
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:49621 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbbA1Udo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:33:44 -0500
Message-ID: <54C9049C.1080305@nexus-software.ie>
Date: Wed, 28 Jan 2015 15:47:40 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1422457242-18095-1-git-send-email-pure.logic@nexus-software.ie>	<1422457242-18095-2-git-send-email-pure.logic@nexus-software.ie> <CAHp75Vee5c+U+gkZQFwSKBWftC=jEtkdTe82bT-jCEAfFKe5zQ@mail.gmail.com>
In-Reply-To: <CAHp75Vee5c+U+gkZQFwSKBWftC=jEtkdTe82bT-jCEAfFKe5zQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> One optional (though I suppose not bad) idea is to split test to
> separate module which might go as a separate patch in the series.
>
> After addressing those comments:
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

No issue with that.

Will generate a V6 based on above feedback
