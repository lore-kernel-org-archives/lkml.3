Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaCRA5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:57:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53237 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752598AbaCRA5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:57:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
Date: Tue, 18 Mar 2014 02:13:14 +0100
Message-ID: <2040389.QPkIWC2M7W@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024E1AE0@SHSMSX101.ccr.corp.intel.com>
References: <14866.1394813101@turing-police.cc.vt.edu> <5326E5E8.4070804@intel.com> <1AE640813FDE7649BE1B193DEA596E88024E1AE0@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 18, 2014 12:31:54 AM Zheng, Lv wrote:
> Hi, Rafael
> 
> > From: Wysocki, Rafael J
> > Sent: Monday, March 17, 2014 8:09 PM
> > 
> > On 3/17/2014 5:14 AM, Lv Zheng wrote:
> > > This feature enabled by the following commit is still under development.
> > >
> > >    Commit: cd52379678785b02d7a357988cfba214fdaf92f4
> > >    Subject: ACPICA: Add global option to disable method auto-serialization.
> > >    This change adds an option to disable the auto-serialization of
> > >    methods that create named objects.
> > >
> > > This patch disables it by default temporarily according to the bug reports.
> > 
> > Well, it doesn't restore the 3.14 behavior of acpi_auto_serialize, as
> > far as I can say, so we can't apply it.
> > 
> > I still can drop the commits related to auto-serialization from my
> > acpica branch.  Which commits are they?
> 
> From linux-pm/bleeding-edge branch, I found this series includes the following commits:
> 
> Commit: a0fd108f2da56b769472fc0095616fb370988516
> Author: Lv Zheng <lv.zheng@intel.com>
> Subject: ACPI: Rename kernel parameter "acpi_serialize" to "acpi_no_auto_serialize"
> 
> Commit: 5f1cb4a92e4c4aabd139ff9ca1e11c0e2db2ac59
> Author: Lv Zheng <lv.zheng@intel.com>
> Subject: ACPICA: Remove global option to serialize all control methods.
> 
> Commit: cd52379678785b02d7a357988cfba214fdaf92f4
> Author: Bob Moore <robert.moore@intel.com>
> Subject: ACPICA: Add global option to disable method auto-serialization.
> 
> Commit: f56b05bd111b01141ef74568dc4d262c70295d03
> Author: Lv Zheng <lv.zheng@intel.com>
> Subject: ACPICA: Add additional named objects for the auto-serialize method scan.
> 
> Commit: 27f1899350a1d6baab117c03c87f0e37730047bd
> Author: Bob Moore <robert.moore@intel.com>
> Subject: ACPICA: Add auto-serialization support for ill-behaved control methods.
> 
> Reverting these commits can restore original Linux behavior.
> Please check.

OK, I dropped the five commits above from the acpica branch.

Please check if the current ACPICA material in the bleeding-edge branch of
linux-pm.git looks OK (and let me know either way).

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
