Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3DPGKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:10:43 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:39095
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753923Ab3DPGKk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:10:40 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1366092629.23016.1.camel@leyfoon-vm>
Subject: Re: Linux kernel support -O0 optimization flag?
From: Ley Foon Tan <lftan@altera.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Kenneth Chong Yin Tan <cytan@altera.com>
Date: Tue, 16 Apr 2013 14:10:29 +0800
In-Reply-To: <CAFLxGvw7Cj_wz_A9B+fBR6jYxi+73Ofh-PjUT=FC+iF0AkDQsQ@mail.gmail.com>
References: <1366012739.21182.4.camel@leyfoon-vm>
	 <CAFLxGvw7Cj_wz_A9B+fBR6jYxi+73Ofh-PjUT=FC+iF0AkDQsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 13:16 +0200, richard -rw- weinberger wrote:

> No. If I'm not mistaken we need this to make sure that the compiler
> inlines some functions.
> 
> In your case the compiler failed to compute the BUILD_BUG() macro correctly.
> It depends also on optimization.
> 
Thank you.
So, the supported optimization flags are -O1, -O2, -O3 and -Os?

Regards
LFTAN

