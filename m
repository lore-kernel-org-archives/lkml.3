Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbaAaPnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:43:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45243 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:43:45 -0500
Message-ID: <52EBC499.2070302@ti.com>
Date: Fri, 31 Jan 2014 10:43:21 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <ivan.khoronzhuk@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: keystone: switch to use runtime pm
References: <1391174426-13773-1-git-send-email-grygorii.strashko@ti.com> <20140131151955.GB20736@saruman.home>
In-Reply-To: <20140131151955.GB20736@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014 10:19 AM, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Jan 31, 2014 at 03:20:26PM +0200, Grygorii Strashko wrote:
>> The Keystone PM management layer has been implemented using PM bus for
>> power management clocks. As result, most of Keystone drivers don't need
>> to manage clocks directly. They just need to enable runtime PM and use it
>> to handle their PM state and clocks.
>>
>> Hence, remove clock management code and switch to use runtime PM.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> quite a few weeks back I sent a series enabling runtime pm for all glue
> layers. I'll use that version instead, sorry.
> 
That should be fine but you need to drop clk_*() related code
from that patch. I assume you will send refresh version of it then.

Regards,
Santosh
