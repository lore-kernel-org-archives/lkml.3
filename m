Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462AbaEFA1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 20:27:10 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55040 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933070AbaEFA1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 20:27:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "Zheng, Lv" <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH 20/27] ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_table().
Date: Tue, 06 May 2014 02:43:44 +0200
Message-ID: <6913597.VSrPZ98ePF@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+5PVA58527N76yJ8yNZPAbOz6YepR3RHXtjaV6t0i1nCYwcXg@mail.gmail.com>
References: <cover.1398817612.git.lv.zheng@intel.com> <1AE640813FDE7649BE1B193DEA596E8802559B1C@SHSMSX101.ccr.corp.intel.com> <CA+5PVA58527N76yJ8yNZPAbOz6YepR3RHXtjaV6t0i1nCYwcXg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2014 08:42:46 AM Josh Boyer wrote:
> On Mon, May 5, 2014 at 12:23 AM, Zheng, Lv <lv.zheng@intel.com> wrote:
> > Hi, Rafael
> >
> >> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> >> Sent: Monday, May 05, 2014 8:43 AM
> >>
> >> On Saturday, May 03, 2014 08:59:14 AM Josh Boyer wrote:
> >> > On Tue, Apr 29, 2014 at 10:05 PM, Lv Zheng <lv.zheng@intel.com> wrote:
> >> > > The commit of back porting Linux XSDT validation mechanism has introduced
> >> > > a regreession:
> >> > >   Commit: 671cc68dc61f029d44b43a681356078e02d8dab8
> >> > >   Subject: ACPICA: Back port and refine validation of the XSDT root table.
> >> > > There is a pointer still accessed after unmapping.
> >> > >
> >> > > This patch fixes this issue.  Lv Zheng.
> >> > >
> >> > > Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=73911
> >> > > Buglink: https://bugs.archlinux.org/task/39811
> >> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> >> > > Reported-and-tested-by: Bruce Chiarelli <mano155@gmail.com>
> >> > > Reported-and-tested-by: Spyros Stathopoulos <spystath@gmail.com>
> >> > > Signed-off-by: Bob Moore <robert.moore@intel.com>
> >> > > Cc: <stable@vger.kernel.org> # 3.14.x: 671cc68: ACPICA: Back port and refine validation of the XSDT root table.
> >> >
> >> > This patch should get into 3.15-rcX soon.  It fixes a known regression
> >> > that prevents booting on machines with AMI firmware, and that is
> >> > present in 3.14 so we need it for stable as well.  Rafael?
> >>
> >> Lv, is it safe to take this patch alone into 3.15-rc?
> >
> > Yes, it's safe to only take this patch to be a regression fix.
> 
> FWIW, Fedora is carrying this on top of 3.14.2 already, and people
> with the impacted machines say it's working for them.  So I agree it
> should be safe.
> 
> Thanks to the both of you.

OK, queued up for 3.15, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
