Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaK0Ll7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:41:59 -0500
Received: from 2.mo68.mail-out.ovh.net ([46.105.52.162]:48829 "EHLO
	mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753329AbaK0Ll6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:41:58 -0500
X-Greylist: delayed 4686 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Nov 2014 06:41:57 EST
MIME-Version: 1.0
In-Reply-To: <20141125182038.04497ec0@gandalf.local.home>
References: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
	<20141107115225.72bc6cbf@gandalf.local.home>
	<545CFAF4.8030104@traphandler.com>
	<CACh+v5MDFZj+NOPWdnMgNthn_DxL3nn=CZJ224vMh7hSf84o4Q@mail.gmail.com>
	<20141125182038.04497ec0@gandalf.local.home>
Date: Thu, 27 Nov 2014 11:23:45 +0100
Message-ID: <CACh+v5Phr-yA8c_bnooR8eLyEpmiMDwCGi2Oy8ArQayuRbeczA@mail.gmail.com>
Subject: Re: [PATCH] arm: ftrace: Adds support for ftrace operations
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>, nsekhar@ti.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mingo@redhat.com, Christoffer Dall <christoffer.dall@linaro.org>,
        jslaby@suse.cz,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 18136558650284070936
X-Ovh-Remote: 209.85.217.174 (mail-lb0-f174.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrtdeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 0:20 GMT+01:00 Steven Rostedt <rostedt@goodmis.org>:
> On Mon, 24 Nov 2014 10:59:24 +0100
> Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:
>
>> Hi Steve,
>> did you get a chance of running your tests suite on real hardware with
>> this patch? I'd be really interested in the results.
>
> Yes I finally got it working on my beaglebone white. It passed all the
> tests that passed without it. Although I'm not sure this patch itself
> was tested as I didn't have kprobes which might use it.
>
Thanks for testing it. At least it doesn't cause regression.
What do you mean by not having krpobes which might use it ? Are you
thinking of the kprobe optimization based on ftrace ?

JJ

> -- Steve
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
