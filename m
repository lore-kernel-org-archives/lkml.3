Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaDPH1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:27:50 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:48259 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaDPH1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <534DF6B1.30609@realtek.com>
References: <1397199203-2235-1-git-send-email-rogerable@realtek.com>
	<1397201514.1589.0.camel@linux-fkkt.site>
	<20140411102846.GB9801@lee--X1>
	<1397212602.4632.2.camel@linux-fkkt.site>
	<534DF6B1.30609@realtek.com>
Date: Wed, 16 Apr 2014 09:27:48 +0200
Message-ID: <CAPDyKFpaWT0JqwkrYzRZN4g5B5k0NB8hq0BY5yzN-T0pxX55WA@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Add modules for realtek USB card reader
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Roger <rogerable@realtek.com>
Cc: Oliver Neukum <oneukum@suse.de>, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org,
        Wei WANG <wei_wang@realsil.com.cn>, micky <micky_ching@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 April 2014 05:19, Roger <rogerable@realtek.com> wrote:
> On 04/11/2014 06:36 PM, Oliver Neukum wrote:
>>
>> On Fri, 2014-04-11 at 11:28 +0100, Lee Jones wrote:
>>>>>
>>>>> From: Roger Tseng <rogerable@realtek.com>
>>>>>
>>>>> This patchset adds modules to support Realtek USB vendor specific class
>>>>> flash
>>>>> card reader: one base module in MFD subsystem and two host modules in
>>>>> both mmc
>>>>> and memstick subsystems. The architecture is similar to rtsx_pci.
>>>>>
>>>>> This work is done primarily to replace the staging driver:
>>>>> staging/rts5139,
>>>>> which doesn't utilize mmc nor memstick subsystems. Once the patchset or
>>>>> its
>>>>> revision is applied, we may need Greg's help to remove the staging one.
>>>>
>>>>
>>>> Looks good to me.
>>>
>>>
>>> Is that an Ack?
>>
>> Acked-by: Oliver <oneukum@suse.de>
>>
>>         Sorry
>>                 Oliver
>>
> Lee,
>
> Would you apply all of these patches?

I have sent a pull request to Chris, containing the patch with the new
mmc driver. The rest I am fine with if Lee can take though the mfd
tree.

Kind regards
Ulf Hansson

>
>
> Best regards,
> Roger Tseng
