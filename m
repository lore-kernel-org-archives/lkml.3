Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbaGOUKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:10:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58481 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546AbaGOUKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:10:48 -0400
Message-ID: <53C58A9C.6070906@zytor.com>
Date: Tue, 15 Jul 2014 13:10:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Toshi Kani <toshi.kani@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Dave Airlie <airlied@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 0/11] Support Write-Through mapping on x86
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com> <CALCETrVfqBpJaTJCnDH8pZf4-6x6oojv+8Vvm3XudJfhbstdOQ@mail.gmail.com>
In-Reply-To: <CALCETrVfqBpJaTJCnDH8pZf4-6x6oojv+8Vvm3XudJfhbstdOQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 12:53 PM, Andy Lutomirski wrote:
> 
> Note that MTRRs are already partially deprecated: all drivers *should*
> be using arch_phys_wc_add, not mtrr_add, and arch_phys_wc_add is a
> no-op on systems with working PAT.
> 
> Unfortunately, I never finished excising mtrr_add.  Finishing the job
> wouldn't be very hard.
> 

The use of MTRRs in drivers is separate from the MTRR global setup done
by the firmware, though.

	-hpa


