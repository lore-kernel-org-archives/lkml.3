Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3JJPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:45:57 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61204 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab3JJPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <5256C686.6000301@ti.com>
References: <1381354144-7134-1-git-send-email-nm@ti.com>
	<1381361098-8283-1-git-send-email-nm@ti.com>
	<52563BD8.1060703@ti.com>
	<20131010133209.GA13105@kahuna>
	<5256C5D2.9030302@ti.com>
	<5256C686.6000301@ti.com>
Date: Thu, 10 Oct 2013 10:45:51 -0500
X-Google-Sender-Auth: f-deG6YcqVn6qjpKti1SQB7J3Wc
Message-ID: <CAGo_u6r-tfnWFP_FNAm5PdWctuPVvh8-XXDscCw+zKHj0FRM_A@mail.gmail.com>
Subject: Re: [PATCH V6 02/15] ARM: OMAP2+: AM33XX: add lateinit hook for
 calling pm late init
From: Nishanth Menon <nm@ti.com>
To: Joel Fernandes <joelf@ti.com>
Cc: dt list <devicetree@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:23 AM, Joel Fernandes <joelf@ti.com> wrote:
> I see a function of that name already exists. I guess you can leave your patch
> as is then and not have to do this.


Can I consider that as an Acked-by :) ?
Regards,
Nishanth Menon
