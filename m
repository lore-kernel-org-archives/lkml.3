Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3FZN3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:29:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3FZN3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:29:17 -0400
Date: Wed, 26 Jun 2013 06:28:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, yinghai@kernel.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Transparent on-demand memory setup initialization
 embedded in the (GFP) buddy allocator
Message-Id: <20130626062850.a7ce5806.akpm@linux-foundation.org>
In-Reply-To: <20130626092248.GB27025@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
	<1371831934-156971-3-git-send-email-nzimmer@sgi.com>
	<20130623092840.GB13445@gmail.com>
	<20130624203657.GA107621@asylum.americas.sgi.com>
	<20130625073819.GC11420@gmail.com>
	<51C9D1D6.20405@sgi.com>
	<51C9E4B7.2000007@zytor.com>
	<51C9E6CD.5080508@sgi.com>
	<20130626092248.GB27025@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jun 2013 11:22:48 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> except that on 32 TB 
> systems we don't spend ~2 hours initializing 8,589,934,592 page heads.

That's about a million a second which is crazy slow - even my prehistoric desktop
is 100x faster than that.

Where's all this time actually being spent?
