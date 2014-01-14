Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaANBaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:30:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41832 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaANBaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:30:22 -0500
Message-ID: <52D49307.3040406@zytor.com>
Date: Mon, 13 Jan 2014 17:29:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Prarit Bhargava <prarit@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bodo Eggert <7eggert@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        dyoung@redhat.com, linux-acpi@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory mapping
 is specified by user [v2]
References: <1389380698-19361-1-git-send-email-prarit@redhat.com>		 <1389380698-19361-4-git-send-email-prarit@redhat.com>		 <alpine.DEB.2.02.1401111624170.20677@be1.lrz>	 <52D32962.5050908@redhat.com>		 <CAHGf_=qWB81f8fdDdjaXXh1JoSDUsJmcEHwH+CEJ2E-5XWz6qA@mail.gmail.com>		 <52D4793E.8070102@redhat.com> <1389659632.1792.247.camel@misato.fc.hp.com>	 <52D48A9D.7000003@zytor.com> <1389661746.1792.254.camel@misato.fc.hp.com>
In-Reply-To: <1389661746.1792.254.camel@misato.fc.hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 05:09 PM, Toshi Kani wrote:
> 
> In majority of the cases, memmap=exactmap is used for kdump and the
> firmware info is sane.  So, I think we should keep NUMA enabled since it
> could be useful when multiple CPUs are enabled for kdump.
> 

Rather unlikely since all of the kdump memory is likely to sit in a
single node.

	-hpa


