Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab3AWLmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 06:42:24 -0500
Received: from thoth.sbs.de ([192.35.17.2]:34900 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab3AWLmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 06:42:21 -0500
Message-ID: <50FFCC4B.10105@siemens.com>
Date: Wed, 23 Jan 2013 12:40:59 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        "David S. Miller" <davem@davemloft.net>,
        Fenghua Yu <fenghua.yu@intel.com>, Kay Sievers <kay@vrfy.org>,
        linux-ia64@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, sparclinux@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v4 00/13] Add gdb python scripts as kernel debugging helpers
References: <cover.1358787929.git.jan.kiszka@siemens.com> <20130123113221.GA4256@pd.tnic>
In-Reply-To: <20130123113221.GA4256@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-23 12:32, Borislav Petkov wrote:
> Ok, first of all, I gotta say, this is very cool stuff, thanks for doing
> this. I'm playing with your tutorial and I'm having some trouble, see
> below:
> 
> On Mon, Jan 21, 2013 at 06:06:07PM +0100, Jan Kiszka wrote:
>>  o Let's examine the current task a bit:
>>     (gdb) p ().pid
> 
> when I do that, it says:
> 
> (gdb) p ().pid
> A syntax error in expression, near `).pid'

Ouch, my git-send script ate all the "$foo" in the cover letter :(. It
has to be $lx_current, $lx_per_cpu and $container_of. Will write an
add-on patch that adds the tutorial as a text file later on.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
