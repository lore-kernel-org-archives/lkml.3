Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbaD2WqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:46:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54178 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751697AbaD2WqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:46:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: jacob.jun.pan@linux.intel.com, linux-pm@vger.kernel.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com, alan@linux.intel.com, durgadoss.r@intel.com,
        kristen.c.accardi@intel.com
Subject: Re: [PATCH v2 0/4] RAPL driver updates
Date: Wed, 30 Apr 2014 01:02:36 +0200
Message-ID: <2848366.d6jLR9v0Ov@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com> <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 03:33:05 PM David E. Box wrote:
> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> v2: iosf: Remove Kconfig exposure. Make mailbox driver a module.
> 
> David E. Box (1):
>   x86/iosf: Make IOSF driver modular and usable by more drivers
> 
> Jacob Pan (3):
>   powercap/rapl: further relax energy counter checks
>   powercap/rapl: add new cpu ids
>   powercap/rapl: change floor frequency for vallewview

I'm fine with [1-2/4].

[3/4] has to go via the x86 tree and [4/4] probably too, because it
depends on [3/4].

So would you like me to queue up [1-2/4] without the remaining two for 3.16?


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
