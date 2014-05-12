Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbaELNQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:16:11 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37008 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaELNQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:16:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<87k3aspd1h.fsf@wine.dyndns.org>
	<87zjiuymiu.fsf@turtle.gmx.de>
	<CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
Date: Mon, 12 May 2014 09:16:08 -0400
X-Google-Sender-Auth: ynVuJUM0KaDfcM_tejXhP-CSU_I
Message-ID: <CA+5PVA4i1Qu_Hbz4npMCo10KdjUWTtvS4=GmYmdiMHSO8QZp2Q@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sven Joachim <svenjoac@gmx.de>, Alexandre Julliard <julliard@winehq.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, info@kobaltwit.be
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 12:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 7, 2014 at 2:18 AM, Sven Joachim <svenjoac@gmx.de> wrote:
>>
>> It seems that at least some 32-bit programs are also broken, since after
>> upgrading the kernel to 3.14.3 I can no longer start my old chess
>> database program:

Now that this has hit 3.14.y stable, we have another report of this
commit breaking something in Wine, this time MS Access 2000:

https://bugzilla.redhat.com/show_bug.cgi?id=1096725 (reporter now CC'd)

> So for backporting (and for 3.15) maybe this (TOTALLY UNTESTED) patch
> would be acceptable.

I don't think your patch went anywhere.  I have no idea if you want to
push that or revert or just tell people to run old apps in 32-bit
guests at this point.  Just forwarding on the information.

josh
