Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaFQJw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:52:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36353 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151AbaFQJwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:52:24 -0400
Message-ID: <53A00FCE.7050101@ti.com>
Date: Tue, 17 Jun 2014 12:52:14 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>, <balbi@ti.com>,
        <dmurphy@ti.com>, <mugunthanvnm@ti.com>, <nsekhar@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v7 0/5] Input: pixcir_i2c_ts: Add Type-B Multi-touch and
 DT support
References: <1402997507-9736-1-git-send-email-rogerq@ti.com> <20140617095132.GR17845@atomide.com>
In-Reply-To: <20140617095132.GR17845@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 12:51 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140617 02:33]:
>> Hi Dmitry,
>>
>> These are the pending patches that didn't go through in the 3.16 merge window.
>> Please queue them for -next. Thanks.
>>
>> The series does the following
>> - convert to Type-B multi touch protocol
>> - support upto 5 fingers with hardware supplied tracking IDs
>> - device tree support
>>
>> Tony,
>>
>> The last 2 patches fix the touch screen size property in the device tree since
>> we now use the unified touch screen properties.
> 
> OK I acked those two pathes so Dmitry can take them too
> when the driver changes get merged.
> 

Thanks Tony.

cheers,
-roger

