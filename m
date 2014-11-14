Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422961AbaKNXat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:30:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54856 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1422820AbaKNXas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:30:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Len Brown <len.brown@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PM / Domains: Make genpd parameter of pm_genpd_present() const
Date: Sat, 15 Nov 2014 00:51:46 +0100
Message-ID: <2762806.YrISv1gbOW@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141113152651.GA834@amd>
References: <1415644659-2531-1-git-send-email-geert+renesas@glider.be> <CAMuHMdUAN_CgWcTFz+LrRODHtBkKscG2iy0p=zZfgTJMu6ES9Q@mail.gmail.com> <20141113152651.GA834@amd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 04:26:51 PM Pavel Machek wrote:
> On Thu 2014-11-13 16:12:25, Geert Uytterhoeven wrote:
> > Hi Pavel,
> > 
> > On Thu, Nov 13, 2014 at 3:09 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > > Acked-by: Pavel Machek <apvel@ucw.cz>
> > 
> > You've got a new email address? ;-)
> 
> Yes, I decided to typo-squat myself :-). Just kidding.
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

Patch queued up for 3.19, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
