Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3BFJt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:49:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43431 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab3BFJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:49:56 -0500
Message-ID: <51122730.5030801@ti.com>
Date: Wed, 6 Feb 2013 11:49:36 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <sameo@linux.intel.com>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY driver
References: <1359372631-8180-1-git-send-email-rogerq@ti.com> <5110ECF3.7010908@ti.com> <20130205165851.GA1081@kroah.com> <20130205171743.GG25185@atomide.com>
In-Reply-To: <20130205171743.GG25185@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 07:17 PM, Tony Lindgren wrote:
> * Greg KH <gregkh@linuxfoundation.org> [130205 09:00]:
>> On Tue, Feb 05, 2013 at 01:28:51PM +0200, Roger Quadros wrote:
>>> Hi Tony & Greg,
>>>
>>> What's the best way to get these patches in?
>>>
>>> All patches have been acked by respective maintainers.
>>>
>>> If Tony can Ack the arch/arm/mach-omap2 stuff then should I send a
>>> pull request directly to Greg? or the other way round?
>>>
>>> Tony, 
>>> fyi, these patches should not interfere with the dw3c/musb stuff
>>> sent by Felipe & Kishon.
>>
>> I'm fine with Tony just taking them all if he wants to.
> 
> OK. Roger, can you please do me a pull request with these
> against v3.8-rc6?
> 

Tony,

Since this depends on [1] and [2] which are both in linux-next, should
I base it on linux-next?

Another option is to defer this to 3.10 merge window, along with the
DT adaptation for OMAP USB Host.

cheers,
-roger

[1] [PATCH v9 00/20] OMAP USB Host cleanup
https://lkml.org/lkml/2013/1/23/155

[2] [PATCH v2 0/6] USB: Add support for multiple PHYs of same type
https://lkml.org/lkml/2013/1/24/876
