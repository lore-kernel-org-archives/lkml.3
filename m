Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaIKEqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:46:53 -0400
Received: from one.firstfloor.org ([193.170.194.197]:55134 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaIKEqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:46:52 -0400
Date: Thu, 11 Sep 2014 06:46:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Dave Hansen <dave.hansen@intel.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
Message-ID: <20140911044650.GN4120@two.firstfloor.org>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
 <5410724B.8000803@intel.com>
 <CAPAsAGzm29VWz8ZvOu+fVGn4Vbj7bQZAnB11M5ZZXRTQTchj0w@mail.gmail.com>
 <5410D486.4060200@intel.com>
 <9E98939B-E2C6-4530-A822-ED550FC3B9D2@zytor.com>
 <54112512.6040409@oracle.com>
 <54112607.9030303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54112607.9030303@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:33:11PM -0700, H. Peter Anvin wrote:
> On 09/10/2014 09:29 PM, Sasha Levin wrote:
> > On 09/11/2014 12:26 AM, H. Peter Anvin wrote:
> >> Except you just broke PVop kernels.
> > 
> > So is this why v2 refuses to boot on my KVM guest? (was digging
> > into that before I send a mail out).
> > 
> 
> No, KVM should be fine.  It is Xen PV which ends up as a smoldering crater.

Just exclude it in Kconfig? I assume PV will eventually go away anyways.

-Andi
