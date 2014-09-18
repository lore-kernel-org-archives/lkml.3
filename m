Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbaIRJ46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:56:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51159 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaIRJ44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:56:56 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-d9-541aac65c2e5
Message-id: <541AAC64.4080904@samsung.com>
Date: Thu, 18 Sep 2014 11:56:52 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Paul.Zimmerman@synopsys.com, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] usb: dwc2/gadget: improvements for gadget driver
References: <1410252297-13738-1-git-send-email-r.baldyga@samsung.com>
 <20140910203459.GA2350@kroah.com>
In-reply-to: <20140910203459.GA2350@kroah.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xy7qpa6RCDL53alocvF9v0bx4PZvF
	5V1z2CwWLWtltnj0cCurA6vH/rlr2D227P/M6HH8xnYmj8+b5AJYorhsUlJzMstSi/TtErgy
	rva8ZC74wVmx+dw+xgbGH+xdjBwcEgImEvN/J3QxcgKZYhIX7q1n62Lk4hASWMooMfvtalYI
	5yOjxIJd39lAqngFtCSWr1zDCmKzCKhKHF94iQnEZhPQkdjyfQIjiC0qECbx7NdBJoh6QYkf
	k++xgNgiAhoSL4/eArOZBTIkvt17DDZTWMBTYuWdZWC2kECmxKLvM8HmcwroSVzcfQ/sUGYg
	+/5FLYhWeYnNa94yT2AUmIVkwyyEqllIqhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93E
	CAngrzsYlx6zOsQowMGoxMMrISAVIsSaWFZcmXuIUYKDWUmE99dCoBBvSmJlVWpRfnxRaU5q
	8SFGJg5OqQbGGfb/XtxUkr3qM9lzE1eNCrPD/Z2TxH89ERHZ4n2gedU8P53LF1fc1y3ax7RC
	cG337dyi5Y9+8v0zS/u1ZNquuPe/jY42f7Z7zDFnYUvv941+WQ0dBcXy0RefvLrr9aM3W/nd
	0UBv+9fXVqjL/flcKaOZOntG+WnfK9wSW0718D19sGSR2LGyFUosxRmJhlrMRcWJANUrihQ+	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 09/10/2014 10:34 PM, Greg KH wrote:
> On Tue, Sep 09, 2014 at 10:44:51AM +0200, Robert Baldyga wrote:
>> Hi,
>>
>> I have splitted my patchset "usb: dwc2/gadget: fix series" into two series.
>> This patch series contains improvements for dwc2/gadget driver. It's intended
>> for 3.18.
>>
>> Andrzej Pietrasiewicz (1):
>>   usb: dwc2/gadget: Fix comment text
>>
>> Kamil Debski (1):
>>   usb: dwc2/gadget: move phy bus legth initialization
>>
>> Marek Szyprowski (2):
>>   usb: dwc2/gadget: hide some not really needed debug messages
>>   usb: dwc2/gadget: ensure that all fifos have correct memory buffers
>>
>> Robert Baldyga (2):
>>   usb: dwc2/gadget: assign TX FIFO dynamically
>>   usb: dwc2/gadget: disable clock when it's not needed
>>
>>  drivers/usb/dwc2/core.h   |   3 ++
>>  drivers/usb/dwc2/gadget.c | 132 +++++++++++++++++++++++++++++-----------------
>>  2 files changed, 86 insertions(+), 49 deletions(-)
> 
> As these depend on your previous changes, I'll wait until after those
> get merged into Linus's tree before applying them.  Probably sometime
> next week.

As my first patch series already got merged into Linus' tree, I would
like to remind you about my second patch set :)

Thanks
Robert Baldyga
