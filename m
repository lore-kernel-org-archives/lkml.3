Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3AVIhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:37:39 -0500
Received: from goliath.siemens.de ([192.35.17.28]:16741 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3AVIhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:37:36 -0500
Message-ID: <50FE4F85.6000308@siemens.com>
Date: Tue, 22 Jan 2013 09:36:21 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v4 00/13] Add gdb python scripts as kernel debugging helpers
References: <cover.1358787929.git.jan.kiszka@siemens.com> <20130121212129.GR30577@one.firstfloor.org>
In-Reply-To: <20130121212129.GR30577@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-21 22:21, Andi Kleen wrote:
>>
>> And this is a tutorial for the gdb extension using QEMU/KVM as target
>> platform:
> 
> Can you add the tutorial as a file in Documentation? 

Sure, will do.

> Other than that everything looks good to me.

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
