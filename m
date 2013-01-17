Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3AQMrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:47:07 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45872 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3AQMrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:47:06 -0500
Message-ID: <50F7F2B8.8050500@ti.com>
Date: Thu, 17 Jan 2013 14:46:48 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <sameo@linux.intel.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v7 18/22] USB: ehci-omap: Don't free gpios that we didn't
 request
References: <1358422231-24736-1-git-send-email-rogerq@ti.com> <1358422231-24736-19-git-send-email-rogerq@ti.com> <20130117114838.GH18978@arwen.pp.htv.fi>
In-Reply-To: <20130117114838.GH18978@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:48 PM, Felipe Balbi wrote:
> On Thu, Jan 17, 2013 at 01:30:27PM +0200, Roger Quadros wrote:
>> This driver does not request any gpios so don't free them.
>> Fixes L3 bus error on multiple modprobe/rmmod of ehci_hcd
>> with ehci-omap in use.
>>
>> CC: Alan Stern <stern@rowland.harvard.edu>
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> should this go to stable ?
> 
Yes it should.

--
cheers,
-roger
