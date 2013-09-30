Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3I3P5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:57:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43976 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab3I3P5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:57:39 -0400
Message-ID: <52499F43.3010007@ti.com>
Date: Mon, 30 Sep 2013 10:56:51 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 0/9] omap hwspinlock dt support
References: <cover.1379445653.git.s-anna@ti.com> <5245A8CA.4020805@ti.com> <alpine.DEB.2.02.1309300309530.17980@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1309300309530.17980@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 10:12 PM, Paul Walmsley wrote:
> Hi
> 
> On Fri, 27 Sep 2013, Suman Anna wrote:
> 
>> Paul,
>> The hwmod data patches needs to be merged only after the respective DT
>> node patches are merged, without which the hwmod entry will not have a
>> base address while enabling and idling (using sysc) the hwmod during
>> hwmod initialization.
> 
> Hmm, ideally there shouldn't be a merge dependency here. Could you please 
> send a patch to the hwmod core that logs a warning and skips the operation 
> in these circumstances?  Or maybe just skips the registration of the 
> device?
> 

Yes, will look into this. This is not specific to hwspinlock, but may be
seen with others as well if the omap_hwmod_addr_space or its equivalent
is not populated.

regards
Suman

