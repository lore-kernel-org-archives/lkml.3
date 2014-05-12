Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbaELL77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 07:59:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56055 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751115AbaELL74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 07:59:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Stratos Karafotis <stratosk@semaphore.gr>, dirk.brandewie@gmail.com,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 4/5] intel_pstate: Remove C0 tracking
Date: Mon, 12 May 2014 14:16:41 +0200
Message-ID: <5349714.j69a5Fx52S@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5370318D.2010309@semaphore.gr>
References: <1399579047-5792-1-git-send-email-dirk.j.brandewie@intel.com> <CADmjqpOnzRrB8gJsmHWG=4bvhERLovnKyP0Pcki_uVJ3qpfD0g@mail.gmail.com> <5370318D.2010309@semaphore.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 12, 2014 05:27:25 AM Stratos Karafotis wrote:
> Hi,
> 

[cut]

> 
> With this patch, my CPU (Core i7-3770 @ 3.90GHz) seems to never use lowest
> frequencies. Even on an idle system I get always ~2GHz. Normally,
> on an idle system it used to be 1.6GHz.
> On very small loads (mp3 decoding) the CPU goes up to 2.7G GHz (it used to
> be 1.6GHz)
> 
> Reverting, this patch on my local build, the problem is resolved.

Dirk, seriously, I can't regard this as a fix that can go into -rc6.

Which of the other patch in the series are must-go for 3.15?  [1-2/5] I guess?
And do we need [2/5] it in -stable too?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
