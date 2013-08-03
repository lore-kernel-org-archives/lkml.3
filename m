Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3HCPu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 11:50:58 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:57081 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3HCPu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 11:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <51FC1A91.3080401@wwwdotorg.org>
References: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
	<51FC1A91.3080401@wwwdotorg.org>
Date: Sat, 3 Aug 2013 17:50:54 +0200
Message-ID: <CANq1E4Tf1fKvcamJ92yBhYA9bLPS=sgJDKAFa+-+M4s8Xfa69g@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/8] x86 platform framebuffers
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-fbdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Aug 2, 2013 at 10:46 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/02/2013 06:05 AM, David Herrmann wrote:
>> Hi
>>
>> I cut down my previous series to no longer include the SimpleDRM driver. If
>> anyone is interested, you can find it here:
>>   http://lwn.net/Articles/558104/
>> I will resend it once these preparation patches are in.
>>
>> Changes since v2:
>>  - added common x86 formats (reported by hpa) (patch #5)
>
> So I assume this is V3; patch subject doesn't say so:-)

Whoops, my bad, sorry. It's v3, yes.

> ...
>> @Stephen: I wasn't sure whether you tested the efi/vesa framebuffer changes,
>> too, so I didn't add your tested-by there. And I changed patch #5 so I dropped
>> it there, too. Thanks for testing!
>
> Yes, I'm only testing on ARM platforms using simplefb, not any x86
> platforms. This latest version seems to work fine, so feel free to
> re-apply by tested-by where appropriate.

That's what I thought. Thanks for verifying.

Cheers
David
