Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaCKX6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:58:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55110 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755561AbaCKX6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:58:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH v2] PM: Add missing "freeze" state
Date: Wed, 12 Mar 2014 01:13:43 +0100
Message-ID: <2220604.AbfOKST42n@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdVPLMm90aSHfY5UugMgX93iT61Q+oTW72CK-x-huNuRjg@mail.gmail.com>
References: <1394536091-28881-1-git-send-email-geert@linux-m68k.org> <20140311124006.GA14565@amd.pavel.ucw.cz> <CAMuHMdVPLMm90aSHfY5UugMgX93iT61Q+oTW72CK-x-huNuRjg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 02:13:59 PM Geert Uytterhoeven wrote:
> Hi Pavel,
> 
> On Tue, Mar 11, 2014 at 1:40 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > On Tue 2014-03-11 12:08:11, Geert Uytterhoeven wrote:
> >> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> >
> > Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> Thanks!
> 
> > Is it going to go in through the trivial tree?
> 
> I didn't send this to trivial, so please take it through the PM tree.

Queued up for 3.15 along with the other two commens cleanups in the runtime PM
and hibernation code.  Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
