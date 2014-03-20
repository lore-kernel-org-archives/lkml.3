Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbaCTMGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:06:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56019 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758275AbaCTMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:06:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 1/2] PM: Correct whitespace errors in <linux/pm.h>
Date: Thu, 20 Mar 2014 13:22:05 +0100
Message-ID: <9150659.AE7ZjEGHLS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdVZ6VS3zfZ0Li6MEd7tkTdxfRz96L74z0GsfXvxj+cDVA@mail.gmail.com>
References: <1395087971-31897-1-git-send-email-geert@linux-m68k.org> <6636992.81rGEKjTqL@vostro.rjw.lan> <CAMuHMdVZ6VS3zfZ0Li6MEd7tkTdxfRz96L74z0GsfXvxj+cDVA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 20, 2014 08:54:39 AM Geert Uytterhoeven wrote:
> Hi Rafael,
> 
> On Wed, Mar 19, 2014 at 11:50 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, March 17, 2014 09:26:10 PM Geert Uytterhoeven wrote:
> >> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >
> > Why exactly are they errors?
> 
> checkpatch.pl says: "WARNING: please, no space before tabs",
> Vim (with "let c_space_errors=1") shows them in red.

Fair enough.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
