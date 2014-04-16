Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaDPDU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:20:59 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57792 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaDPDUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:20:50 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3G3K3AB006250, This message is accepted by code: ctloc85258
Message-ID: <534DF6B1.30609@realtek.com>
Date: Wed, 16 Apr 2014 11:19:13 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>, Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v7 0/4] Add modules for realtek USB card reader
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>	 <1397201514.1589.0.camel@linux-fkkt.site> <20140411102846.GB9801@lee--X1> <1397212602.4632.2.camel@linux-fkkt.site>
In-Reply-To: <1397212602.4632.2.camel@linux-fkkt.site>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 06:36 PM, Oliver Neukum wrote:
> On Fri, 2014-04-11 at 11:28 +0100, Lee Jones wrote:
>>>> From: Roger Tseng <rogerable@realtek.com>
>>>>
>>>> This patchset adds modules to support Realtek USB vendor specific class flash
>>>> card reader: one base module in MFD subsystem and two host modules in both mmc
>>>> and memstick subsystems. The architecture is similar to rtsx_pci.
>>>>
>>>> This work is done primarily to replace the staging driver: staging/rts5139,
>>>> which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
>>>> revision is applied, we may need Greg's help to remove the staging one.
>>>
>>> Looks good to me.
>>
>> Is that an Ack?
> Acked-by: Oliver <oneukum@suse.de>
>
> 	Sorry
> 		Oliver
>
Lee,

Would you apply all of these patches?


Best regards,
Roger Tseng
