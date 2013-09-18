Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab3IRAtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:49:49 -0400
Received: from nm24-vm3.access.bullet.mail.gq1.yahoo.com ([216.39.63.82]:37963
	"EHLO nm24-vm3.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab3IRAtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:49:47 -0400
X-Yahoo-Newman-Id: 621975.93478.bm@smtp114.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7OuB_QcVM1l1QEQvMHxo1uqXArD_knbThlc6kStu65c3ozW
 LW1yPL6J7GNsgdhox2_H5YIFbot86SQVoSiNgPv7oyd86skBpP8I.b9ZT8YM
 U_8v5onmwB.qgPgWRcwxB.qY_03O4hZfGL.K1Mp.aVPPmzp0UZCAPMNE1e5V
 BXlPQnrhVM3oJ4whjO4ZazLjdgM_w5bxPbkmHaGn_6R07wNN4WUro8zc1zdW
 Yc59pre4yX.OPymJAILdewREWb5t0ZV99UbOYLo7vwSbBiG46_qtFiHKKU1o
 tfDfTpW7kCXJ4Tk9cev_4CEWP.taXgEqNl9AfrlMFC0oSTI.1zuhe1q4vx1D
 5R05EsKbG6Ke6hSijcJdAeetPTq6MUqdEPbjIOXYO3LkzKnbseoe2rYwsOe5
 3GE62_tBu3Gg_SQ4gON0.PhCjomDHb2Hzf8rJ75L1_4LIFEre5whNk6HWN9f
 SZie2NKFeZs9kqeHEAgpIyMIcd.597KBjzQN1e8CJjKm.Nl.g_1dIZhbx0WP
 _avdFILfPBfU95MBx14lbsoA9X4bANdxVFhaVMAK.f490zOr5_HPfyc2z5Mj
 B4x.pORHLF_3_RoY.ey7D.13qeg7LQH5_ikcIR7KkRGjj5rwGIbH.RegNa7g
 GUHq4p5nU
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@216.100.252.242 with )
        by smtp114.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 17:49:45 -0700 PDT
From: Alexey Neyman <stilor@att.net>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH PING] Fix coalescing of host bridge windows in arch/x86/pci/acpi.c
Date: Tue, 17 Sep 2013 17:49:44 -0700
Message-ID: <5988412.MKVQTjx6Fi@mistral>
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.5; x86_64; ; )
In-Reply-To: <523794EE.10505@hurleysoftware.com>
References: <201309121719.17447.stilor@att.net> <201309160941.54844.stilor@att.net> <523794EE.10505@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2649268.u3OXIaMfJF"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2649268.u3OXIaMfJF
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

[Resending without HTML part - sorry for possible duplicates]

As requested by Peter, resending the patch with ACPI/x86 maintainers CC'ed.

Short description:
Make coalesce_windows() handle multiple resource overlaps.

Signed-off-by: Alexey Neyman <stilor@att.net>

Regards,
Alexey.

On Monday, September 16, 2013 07:31:58 PM Peter Hurley wrote:
> [ +cc Bjorn Helgaas, Rafael Wysocki, linux-acpi ]
> 
> On 09/16/2013 12:41 PM, Alexey Neyman wrote:
> > Hi all,
> > 
> > Could anybody review/commit the patch?
> 
> LKML is a pretty general list and maintainers don't typically
> trawl the list for more work to do. The get_maintainer script
> can be used to help determine to whom to address a patch.
> 
> peter@thor:~/src/kernels/next$ ./scripts/get_maintainer.pl -f
> arch/x86/pci/acpi.c Thomas Gleixner <tglx@linutronix.de> (maintainer:X86
> ARCHITECTURE...) Ingo Molnar <mingo@redhat.com> (maintainer:X86
> ARCHITECTURE...)
> "H. Peter Anvin" <hpa@zytor.com> (maintainer:X86 ARCHITECTURE...)
> x86@kernel.org (maintainer:X86 ARCHITECTURE...)
> Bjorn Helgaas <bhelgaas@google.com> (commit_signer:5/8=62%)
> "Rafael J. Wysocki" <rafael.j.wysocki@intel.com> (commit_signer:3/8=38%)
> Feng Tang <feng.tang@intel.com> (commit_signer:1/8=12%)
> Yijing Wang <wangyijing@huawei.com> (commit_signer:1/8=12%)
> Mike Yoknis <mike.yoknis@hp.com> (commit_signer:1/8=12%)
> linux-kernel@vger.kernel.org (open list)
> 
> Regards,
> Peter Hurley
> 
> PS - You'll want to inline your patch as well because as you can see
> replies don't include it.
> 
> > Regards,
> > Alexey.
> > 
> > On Thursday, September 12, 2013 05:19:16 pm Alexey Neyman wrote:
> >> Hi all,
> >> 
> >> I have a board with a BIOS bug that reports the following I/O port
> >> regions
> >> in _CRS on one of the host bridges:
> >> 
> >> 0x0000-0x03af // #0
> >> 0x03e0-0x0cf7 // #1
> >> 0x03b0-0x03bb // #2
> >> 0x03c0-0x03df // #3
> >> 0x0000-0xdfff // #4
> >> 0xf000-0xffff // #5
> >> 
> >> Obviously, region number #4 is erroneous as it overlaps with regions
> >> #0..3.
> >> However, code in coalesce_windows() in arch/x86/pci/acpi.c attempts to
> >> recover from such kind of BIOS bugs by merging the overlapping regions.
> >> Current code expands region #0 to 0x0000-0xdffff and makes region #4
> >> ignored. As a result, overlap of the expanded region #0 with regions
> >> #1..3
> >> remains undetected. As a result, regions #1..3 are inserted into the
> >> resource tree as if they were consumers of the 0x0000-0xdfff regions, and
> >> devices that have resources in one of these regions (e.g. 0x3f6 for
> >> legacy
> >> IDE) have a resource conflict - the kernel does not initialize them.
> >> 
> >> The attached patch makes the code in coalesce_windows() instead ignore
> >> res1
> >> (which is already dealt with), possibly expanding res2 instead. As res2
> >> has
> >> not been reached in the outer loop in coalesce_windows(), the code will
> >> then check for overlaps of the just-expanded resource with the rest of
> >> the
> >> resources.
> >> 
> >> Regards,
> >> Alexey.
--nextPart2649268.u3OXIaMfJF
Content-Disposition: attachment; filename="acpi.c.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="acpi.c.diff"

--- arch/x86/pci/acpi.c.orig	2013-09-12 16:23:06.113813150 -0700
+++ arch/x86/pci/acpi.c	2013-09-12 16:23:56.605813117 -0700
@@ -357,12 +357,12 @@
 			 * the kernel resource tree doesn't allow overlaps.
 			 */
 			if (resource_overlaps(res1, res2)) {
-				res1->start = min(res1->start, res2->start);
-				res1->end = max(res1->end, res2->end);
+				res2->start = min(res1->start, res2->start);
+				res2->end = max(res1->end, res2->end);
 				dev_info(&info->bridge->dev,
 					 "host bridge window expanded to %pR; %pR ignored\n",
-					 res1, res2);
-				res2->flags = 0;
+					 res2, res1);
+				res1->flags = 0;
 			}
 		}
 	}

--nextPart2649268.u3OXIaMfJF--

