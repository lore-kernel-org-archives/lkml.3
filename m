Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaIJUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:14:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57458 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaIJUO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:14:57 -0400
Message-ID: <5410B10A.4030207@zytor.com>
Date: Wed, 10 Sep 2014 13:14:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, Andy Lutomirski <luto@amacapital.net>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yigal Korman <yigal@plexistor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 2/6] x86, mm, pat: Change reserve_memtype() to handle
 WT
References: <1410367910-6026-1-git-send-email-toshi.kani@hp.com>	 <1410367910-6026-3-git-send-email-toshi.kani@hp.com>	 <CALCETrXRjU3HvHogpm5eKB3Cogr5QHUvE67JOFGbOmygKYEGyA@mail.gmail.com> <1410377428.28990.260.camel@misato.fc.hp.com>
In-Reply-To: <1410377428.28990.260.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 12:30 PM, Toshi Kani wrote:
> 
> When WT is unavailable due to the PAT errata, it does not fail but gets
> redirected to UC-.  Similarly, when PAT is disabled, WT gets redirected
> to UC- as well.
> 

But on pre-PAT hardware you can still do WT.

	-hpa

