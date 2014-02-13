Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBMPvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:51:04 -0500
Received: from blu0-omc2-s8.blu0.hotmail.com ([65.55.111.83]:28104 "EHLO
	blu0-omc2-s8.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751713AbaBMPvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:51:02 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Feb 2014 10:51:02 EST
X-TMN: [RDxT9+6CK/5RcAoxU3ZG2sXYUNdgFX7U]
X-Originating-Email: [maarten-baert@hotmail.com]
Message-ID: <BLU0-SMTP662C7668A34D62A4E193ACE29D0@phx.gbl>
Date: Thu, 13 Feb 2014 16:45:50 +0100
From: Maarten Baert <maarten-baert@hotmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: sbsiddha@gmail.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, George Spelvin <linux@horizon.com>,
        Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>	 <CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>	 <CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>	 <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>	 <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>	 <1391325599.6481.5.camel@europa>	 <CA+55aFzz8a7K+KSB_TkGb1ih1hAg09-0TQusQgE5vwMJGegHDw@mail.gmail.com> <1391410583.3801.6.camel@europa>
In-Reply-To: <1391410583.3801.6.camel@europa>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Feb 2014 15:45:53.0303 (UTC) FILETIME=[AD50CA70:01CF28D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/14 07:56, Suresh Siddha wrote:
> Here is the second patch, which should fix the issue reported in this
> thread. Maarten, Nate, George, please give this patch a try as is and
> see if it helps address the issue you ran into.
I can confirm that your patch fixes the bug I reported (core dump in
ecryptfs on ext4). I tested it with Linux 3.12.9 (which is what Arch
Linux uses at the moment).

Maarten Baert
