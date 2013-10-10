Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab3JJPyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:54:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42937 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757215Ab3JJPyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:54:02 -0400
Message-ID: <5256CD7C.5080909@ti.com>
Date: Thu, 10 Oct 2013 10:53:32 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: dt list <devicetree@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, lkml <linux-kernel@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V6 02/15] ARM: OMAP2+: AM33XX: add lateinit hook for calling
 pm late init
References: <1381354144-7134-1-git-send-email-nm@ti.com> <1381361098-8283-1-git-send-email-nm@ti.com> <52563BD8.1060703@ti.com> <20131010133209.GA13105@kahuna> <5256C5D2.9030302@ti.com> <5256C686.6000301@ti.com> <CAGo_u6r-tfnWFP_FNAm5PdWctuPVvh8-XXDscCw+zKHj0FRM_A@mail.gmail.com>
In-Reply-To: <CAGo_u6r-tfnWFP_FNAm5PdWctuPVvh8-XXDscCw+zKHj0FRM_A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 10:45 AM, Nishanth Menon wrote:
> On Thu, Oct 10, 2013 at 10:23 AM, Joel Fernandes <joelf@ti.com> wrote:
>> I see a function of that name already exists. I guess you can leave your patch
>> as is then and not have to do this.
> 
> 
> Can I consider that as an Acked-by :) ?

Yes, sure, for this particular patch:

Acked-by: Joel Fernandes <joelf@ti.com>

thanks,

-Joel

