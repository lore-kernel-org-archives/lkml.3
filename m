Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762580Ab3DCOyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:54:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45152 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760979Ab3DCOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:54:04 -0400
Message-ID: <515C427E.4020101@ti.com>
Date: Wed, 3 Apr 2013 17:53:50 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 01/21] usb: phy: nop: Add some parameters to platform
 data
References: <1363794300-31526-1-git-send-email-rogerq@ti.com> <1363794300-31526-2-git-send-email-rogerq@ti.com> <20130320155555.GG1567@arwen.pp.htv.fi> <20130320161324.GL16413@atomide.com> <20130320161947.GJ1567@arwen.pp.htv.fi> <20130402172129.GT10155@atomide.com>
In-Reply-To: <20130402172129.GT10155@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 08:21 PM, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [130320 09:24]:
>> On Wed, Mar 20, 2013 at 09:13:24AM -0700, Tony Lindgren wrote:
>>> * Felipe Balbi <balbi@ti.com> [130320 09:00]:
>>>> On Wed, Mar 20, 2013 at 05:44:40PM +0200, Roger Quadros wrote:
>>>>> Add clk_rate parameter to platform data. If supplied, the
>>>>> NOP phy driver will program the clock to that rate during probe.
>>>>>
>>>>> Also add 2 flags, needs_vcc and needs_reset.
>>>>> If the flag is set and the regulator couldn't be found
>>>>> then the driver will bail out with -EPROBE_DEFER.
>>>>>
>>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>>> Acked-by: Felipe Balbi <balbi@ti.com>
>>>>
>>>> Hi Tony,
>>>>
>>>> maybe you might prefer to merge commit 1f0972f from my next branch which
>>>> is exactly this patch. Basically, if you:
>>>>
>>>> $ git fetch git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git next
>>>> $ git merge 1f0972f
>>>>
>>>> you get $SUBJECT and can apply the others without fear of conflicts
>>>> later.
>>>
>>> OK thanks will use commit 1f0972f, so let's consider that commit immutable.
>>
>> yeah, once it hits my 'next' branch, I don't rebase anymore.
> 
> I've applied the board related patchs into omap-for-v3.10/usb that's based
> on commit 1f0972f.

Thanks Tony.

cheers,
-roger
