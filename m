Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3HBUqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:46:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49211 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3HBUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:46:13 -0400
Message-ID: <51FC1A91.3080401@wwwdotorg.org>
Date: Fri, 02 Aug 2013 14:46:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH RESEND 0/8] x86 platform framebuffers
References: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1375445127-15480-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 06:05 AM, David Herrmann wrote:
> Hi
> 
> I cut down my previous series to no longer include the SimpleDRM driver. If
> anyone is interested, you can find it here:
>   http://lwn.net/Articles/558104/
> I will resend it once these preparation patches are in.
> 
> Changes since v2:
>  - added common x86 formats (reported by hpa) (patch #5)

So I assume this is V3; patch subject doesn't say so:-)

...
> @Stephen: I wasn't sure whether you tested the efi/vesa framebuffer changes,
> too, so I didn't add your tested-by there. And I changed patch #5 so I dropped
> it there, too. Thanks for testing!

Yes, I'm only testing on ARM platforms using simplefb, not any x86
platforms. This latest version seems to work fine, so feel free to
re-apply by tested-by where appropriate.
