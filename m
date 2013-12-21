Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab3LUAJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 19:09:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49386 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab3LUAJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 19:09:13 -0500
Message-ID: <52B4DC15.6090004@zytor.com>
Date: Fri, 20 Dec 2013 16:08:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Prarit Bhargava <prarit@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Morgan, Janet" <janet.morgan@intel.com>,
        "ruiv.wang@gmail.com" <ruiv.wang@gmail.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v3]
References: <1387554609-9823-1-git-send-email-prarit@redhat.com> <20131220225624.GD22695@tassilo.jf.intel.com> <3908561D78D1C84285E8C5FCA982C28F31D8F0E9@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D8F0E9@ORSMSX106.amr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 03:06 PM, Luck, Tony wrote:
>> I haven't double checked, but I'm assuming the hot plug locks are held
>> while you are doing this.
> 
> I dug into that when looking at v2 - the whole thing is under "stop_machine()"
> so locking was not an issue.
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> 

Awesome, thank you!  I have queued this up for Linus already as a fix
for 3.13, as it seems important enough.

	-hpa


