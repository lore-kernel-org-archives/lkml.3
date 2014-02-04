Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaBDPcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:32:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36089 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaBDPcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:32:50 -0500
Message-ID: <52F1081F.3040006@ti.com>
Date: Tue, 4 Feb 2014 17:32:47 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] usb: musb: host: fixes for 3.14-rc
References: <1391520349-26192-1-git-send-email-rogerq@ti.com> <20140204152725.GB8556@kroah.com>
In-Reply-To: <20140204152725.GB8556@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 05:27 PM, Greg KH wrote:
> On Tue, Feb 04, 2014 at 03:25:47PM +0200, Roger Quadros wrote:
>> Hi Greg,
>>
>> Patch 1 fixes SuperSpeed hub enumeration on beaglebone.
>> Patch 2 fixes remote-wakeup resume on beaglebone.
>>
>> Felipe has Acked the 1st patch but still needs to Ack the 2nd one.
>>
>> Patches are based on 3.14-rc1
> 
> Why wouldn't these come into my tree from Felipe like normal?  Why
> should I take them?
> 
> confused,

I should have mentioned it earlier. Felipe told me to send it to you as he's out
on vacations. But never-mind, I can wait till he picks it up.

cheers,
-roger
