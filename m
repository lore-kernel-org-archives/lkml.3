Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab3GZAuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 20:50:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab3GZAuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 20:50:16 -0400
Message-ID: <51F1C7B4.2010100@zytor.com>
Date: Thu, 25 Jul 2013 17:49:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@kernel.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
        torvalds@linux-foundation.org
Subject: Re: Ugly patches for stolen reservation
References: <1374770269-3223-1-git-send-email-jbarnes@virtuousgeek.org> <20130725200551.GA16719@gmail.com> <5304d042-6f8f-4754-9d19-df62662d19f4@email.android.com> <20130725161715.50d85926@jbarnes-desktop>
In-Reply-To: <20130725161715.50d85926@jbarnes-desktop>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 04:17 PM, Jesse Barnes wrote:
> Well, it's ok if the boot loader writes to this memory, the worst
> that'll happen is you'll see garbage on the screen.  If the boot loader
> tries to do MMIO mapping on top it'll get into trouble... but why would
> it do that?
> 
> Jesse

Much worse: it could be hunting for a place to put the kernel, and put
it there.

	-hpa


