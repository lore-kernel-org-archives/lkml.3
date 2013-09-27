Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3I0E6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 00:58:37 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:59435 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3I0E6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 00:58:31 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Chris Zankel <chris@zankel.net>, "Max Filippov" <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 15/21] of: remove HAVE_ARCH_DEVTREE_FIXUPS
Thread-Topic: [PATCH 15/21] of: remove HAVE_ARCH_DEVTREE_FIXUPS
Thread-Index: AQHOuulu+FGSud2nmEqgnScDZamNLA==
Date: Fri, 27 Sep 2013 04:58:27 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514EAAE@IN01WEMBXA.internal.synopsys.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
 <1380221456-11192-16-git-send-email-robherring2@gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 12:21 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> HAVE_ARCH_DEVTREE_FIXUPS appears to always be needed except for sparc,
> but it is only used for /proc/device-teee and sparc does not enable
> /proc/device-tree. So this option is redundant. Remove the option and
> always enable it. This has the side effect of fixing /proc/device-tree
> on arches such as arm64 which failed to define this option.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx for the continued cleanup.
-Vineet


