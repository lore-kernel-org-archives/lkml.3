Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaDHEZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 00:25:06 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:40726 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaDHEZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 00:25:04 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, "Max Filippov" <jcmvbkbc@gmail.com>,
        "linux-metag@vger.kernel.org" <linux-metag@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux@lists.openrisc.net" <linux@openrisc.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Subject: Re: [PATCH 08/20] of/fdt: consolidate built-in dtb section variables
Thread-Topic: [PATCH 08/20] of/fdt: consolidate built-in dtb section
 variables
Thread-Index: AQHPT4qHMeYKD9X5AEShYbdSke0Yxg==
Date: Tue, 8 Apr 2014 04:23:48 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751ABA59@IN01WEMBXA.internal.synopsys.com>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
 <1396563423-30893-9-git-send-email-robherring2@gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.197.213]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Friday 04 April 2014 03:47 AM, Rob Herring wrote:
> From: Rob Herring <robh@kernel.org>
>
> Unify the various architectures __dtb_start and __dtb_end definitions
> moving them into of_fdt.h.
>
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Vineet Gupta <vgupta@synopsys.com>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Jonas Bonn <jonas@southpole.se>
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: linux-metag@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: linux@lists.openrisc.net
> Cc: linux-xtensa@linux-xtensa.org

Acked-by: Vineet Gupta <vgupta@synopsys.com>  # arch/arc bits

Thx,
-Vineet
