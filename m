Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3GIVDC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:03:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38846 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3GIVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:03:01 -0400
Message-ID: <51DC7A80.9030201@wwwdotorg.org>
Date: Tue, 09 Jul 2013 15:02:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Peter Jones <pjones@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 00/14] Platform Framebuffers and SimpleDRM
References: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372940714-12470-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 06:25 AM, David Herrmann wrote:
> Hi
> 
> This series changes the way we handle firmware framebuffers on x86 systems. On
> other architectures the recently introduced "simple-framebuffer"
> platform-devices provide a sane and proper way to handle firmware framebuffers.
> So why not use it on x86, too?

Tested-by: Stephen Warren <swarren@nvidia.com>

(This time I didn't see any issue with the FB content being blank; I
must have forgotten a console= command-line parameter or something the
last time around)
