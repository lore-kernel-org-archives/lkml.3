Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3GJR2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:28:38 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:34513 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3GJR2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <51DC7A80.9030201@wwwdotorg.org>
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
	<51DC7A80.9030201@wwwdotorg.org>
Date: Wed, 10 Jul 2013 19:28:36 +0200
Message-ID: <CANq1E4S0WnG1SAPefCJ5sp-GR1etWZDPnP6bGHy-G+LUpqTmQQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/14] Platform Framebuffers and SimpleDRM
From: David Herrmann <dh.herrmann@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Jul 9, 2013 at 11:02 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 07/04/2013 06:25 AM, David Herrmann wrote:
>> Hi
>>
>> This series changes the way we handle firmware framebuffers on x86 systems. On
>> other architectures the recently introduced "simple-framebuffer"
>> platform-devices provide a sane and proper way to handle firmware framebuffers.
>> So why not use it on x86, too?
>
> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> (This time I didn't see any issue with the FB content being blank; I
> must have forgotten a console= command-line parameter or something the
> last time around)

I think I had some error in the pseudo_palette handling (which I now
copied from simplefb.c), but I am not sure why it didn't work in v1.
Thanks a lot for testing!

Regards
David
