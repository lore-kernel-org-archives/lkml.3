Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbaEHUkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:40:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39802 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbaEHUkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:40:40 -0400
Message-ID: <536BEBA7.7@zytor.com>
Date: Thu, 08 May 2014 13:40:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Sven Joachim <svenjoac@gmx.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexandre Julliard <julliard@winehq.org>,
        Brian Gerst <brgerst@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com> <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com> <CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com> <87k3aspd1h.fsf@wine.dyndns.org> <87zjiuymiu.fsf@turtle.gmx.de> <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com> <536A68B1.6070500@zytor.com> <87vbtgahxs.fsf@turtle.gmx.de> <4b728523-2e82-42f1-997c-792ce8e3219f@email.android.com>
In-Reply-To: <4b728523-2e82-42f1-997c-792ce8e3219f@email.android.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 06:50 AM, H. Peter Anvin wrote:
> Actually it could use KVM instead of CPU emulation on nearly all modern processors...

That being said, it would be cool if someone would either port the
lredir backend (MFS) into Qemu, or finish the 9P front end I started
writing at one point, but probably will never have time to finish.
	
	-hpa


