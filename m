Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbaELQwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:52:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:13149 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbaELQwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1036,1389772800"; 
   d="scan'208";a="537751273"
Message-ID: <5370FC3F.30609@linux.intel.com>
Date: Mon, 12 May 2014 09:52:15 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Sven Joachim <svenjoac@gmx.de>, Alexandre Julliard <julliard@winehq.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        info@kobaltwit.be
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>	<87k3aspd1h.fsf@wine.dyndns.org>	<87zjiuymiu.fsf@turtle.gmx.de>	<CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com> <CA+5PVA4i1Qu_Hbz4npMCo10KdjUWTtvS4=GmYmdiMHSO8QZp2Q@mail.gmail.com>
In-Reply-To: <CA+5PVA4i1Qu_Hbz4npMCo10KdjUWTtvS4=GmYmdiMHSO8QZp2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 06:16 AM, Josh Boyer wrote:
> On Wed, May 7, 2014 at 12:57 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Wed, May 7, 2014 at 2:18 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>>>
>>> It seems that at least some 32-bit programs are also broken, since after
>>> upgrading the kernel to 3.14.3 I can no longer start my old chess
>>> database program:
> 
> Now that this has hit 3.14.y stable, we have another report of this
> commit breaking something in Wine, this time MS Access 2000:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1096725 (reporter now CC'd)
> 
>> So for backporting (and for 3.15) maybe this (TOTALLY UNTESTED) patch
>> would be acceptable.
> 
> I don't think your patch went anywhere.  I have no idea if you want to
> push that or revert or just tell people to run old apps in 32-bit
> guests at this point.  Just forwarding on the information.
> 

Linus is off the net at the moment.  Someone needs to take his patch and
test it/clean it up.

	-hpa


