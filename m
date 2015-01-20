Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbbATVjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 16:39:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61119 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753123AbbATVjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 16:39:10 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Box, David E" <david.e.box@intel.com>,
        "Moore, Robert" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brown, Len" <len.brown@intel.com>
Subject: Re: About 2 ACPICA table patches
Date: Tue, 20 Jan 2015 23:01:45 +0100
Message-ID: <4186663.SkfriU6CkL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAE1zotKtpWh3VOR7p95_TB278fTqT1itMwLr3BPh4DtW7=Y6+w@mail.gmail.com>
References: <1AE640813FDE7649BE1B193DEA596E88026B7CAD@SHSMSX101.ccr.corp.intel.com> <2627056.UnZ45BKguv@vostro.rjw.lan> <CAE1zotKtpWh3VOR7p95_TB278fTqT1itMwLr3BPh4DtW7=Y6+w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 20, 2015 05:05:07 PM Octavian Purdila wrote:
> On Tue, Jan 20, 2015 at 5:09 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> > On Saturday, January 17, 2015 05:02:31 PM Octavian Purdila wrote:
> > > On Fri, Jan 16, 2015 at 11:44 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> > > > Hi, Octavian
> > > >
> > >
> > > Hi Lv,
> > >
> > > > I noticed there are 2 patches you've sent to the community.
> > > > But unfortunately I didn't find them in my mailbox.
> > > > Let me comment you here.
> > > >
> > > > https://patchwork.kernel.org/patch/5501621/
> > > > This patch seem to be correct.
> > > > But Rafael should merge it directly via Linux because acpi_unload_table_id() is not in the ACPICA upstream.
> > >
> > > OK, thanks for letting me know. Rafel, does the patch look ok to you?
> >
> > I'm Rafael, but that's OK.
> >
> 
> Oops, sorry about that, typo :(
> 
> What about patch 3 of the original set [1], does it look better now?
> 
> [1] https://lkml.org/lkml/2014/12/16/290

I'm not entirely fond of it to be honest, but let me reply to it directly
(if I can find the original).


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
