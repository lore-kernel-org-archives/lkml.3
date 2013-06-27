Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab3F0UM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:12:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60602 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3F0T4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:56:50 -0400
Message-ID: <51CC98E6.1020104@ti.com>
Date: Thu, 27 Jun 2013 14:56:22 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Documentation: dt: bindings: TI WiLink modules
References: <1372149330-24335-1-git-send-email-coelho@ti.com>   <51CBC1C8.1040301@gmail.com> <1372322851.18889.53.camel@cumari.coelho.fi>   <20130627125131.GA27285@kahuna>  <1372337887.8383.12.camel@cumari.coelho.fi>   <CAGo_u6qbt9dANgKq49xR=1qsCpUBhmVaPL4EK04XvTw+=4Z23g@mail.gmail.com>   <1372339148.8383.17.camel@cumari.coelho.fi> <51CC3CEE.3050004@ti.com>   <1372339810.8383.20.camel@cumari.coelho.fi>   <CAGo_u6pWZX9gbHgBae=gcWk8i6-TnhxH1TdM9QdEDLTow6Pn5A@mail.gmail.com>  <1372359090.21065.12.camel@cumari.coelho.fi> <51CC8E80.5030206@ti.com> <1372362418.21065.25.camel@cumari.coelho.fi>
In-Reply-To: <1372362418.21065.25.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2013 02:46 PM, Luciano Coelho wrote:
> On Thu, 2013-06-27 at 14:12 -0500, Nishanth Menon wrote:
[...]
>> Indexes to another entity is always a maintenance burden in the longer
>> run and needs judicious control. If it is possible to avoid it by
>> selecting the right parameters, I am a hard advocate for the same.
>
> I tend to agree.  But you need a balance.  In theory you're right.  But
> I think if you take the real world example, it is over-engineering.
>
> Anyway, if you *really* think this needs to be changed, I think we're in
> a deadlock here and I'd like to hear other people's opinions.  I don't
> mind making the change, but I'm still not convinced it is worth it,
> since it just adds complexity.
>
> And hey, this is too much bikeshedding for such a small detail.
Lol :)

Alrite, if no one else is complaining, I am not going to block it either.

-- 
Regards,
Nishanth Menon
