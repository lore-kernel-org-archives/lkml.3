Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3KTE6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:58:52 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:57746 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3KTE6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:58:50 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <rob.herring@calxeda.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] arc: Use NULL as the default DTB
Thread-Topic: [PATCH 2/9] arc: Use NULL as the default DTB
Thread-Index: AQHO5RhGcmry/eqS50adiKWGVBJcaw==
Date: Wed, 20 Nov 2013 04:58:47 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075156ABC@IN01WEMBXA.internal.synopsys.com>
References: <5283A000.8090007@gmail.com>
 <1384859554-27268-1-git-send-email-geert@linux-m68k.org>
 <1384859554-27268-2-git-send-email-geert@linux-m68k.org>
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

On 11/19/2013 04:42 PM, Geert Uytterhoeven wrote:
> early_init_dt_scan() now takes care of falling back to the built-in DTB.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Vineet Gupta <vgupta@synopsys.com>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet
