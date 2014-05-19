Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaESHvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:51:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54500 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaESHvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:51:06 -0400
Message-ID: <5379B7E2.30904@ti.com>
Date: Mon, 19 May 2014 10:50:58 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <balbi@ti.com>, <dmurphy@ti.com>,
        <mugunthanvnm@ti.com>, <nsekhar@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 7/7] Input: pixcir_i2c_ts: Add device tree support
References: <1399374372-29123-1-git-send-email-rogerq@ti.com> <1399374372-29123-8-git-send-email-rogerq@ti.com> <20140519055421.GF29386@core.coreip.homeip.net>
In-Reply-To: <20140519055421.GF29386@core.coreip.homeip.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 08:54 AM, Dmitry Torokhov wrote:
> On Tue, May 06, 2014 at 02:06:12PM +0300, Roger Quadros wrote:
>> Provide device tree support and binding information.
>> Also provide support for a new chip "pixcir_tangoc".
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  .../bindings/input/touchscreen/pixcir_i2c_ts.txt   | 26 ++++++++
>>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>>  drivers/input/touchscreen/pixcir_i2c_ts.c          | 78 ++++++++++++++++++++++
>>  3 files changed, 105 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
>>
>> diff --git a/Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt b/Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
>> new file mode 100644
>> index 0000000..0ab9505
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
>> @@ -0,0 +1,26 @@
>> +* Pixcir I2C touchscreen controllers
>> +
>> +Required properties:
>> +- compatible: must be "pixcir,pixcir_ts" or "pixcir,pixcir_tangoc"
>> +- reg: I2C address of the chip
>> +- interrupts: interrupt to which the chip is connected
>> +- attb-gpio: GPIO connected to the ATTB line of the chip
>> +- x-size: horizontal resolution of touchscreen
>> +- y-size: vertical resolution of touchscreen
> 
> There is a patch by Sebastian Reichel trying to unify touchscreen OF
> properties, I think it would be nice if we used the same properties
> here.

OK, I'll update this patch.

cheers,
-roger
