Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149Ab3BFX1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:27:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab3BFX1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:27:52 -0500
Message-ID: <5112E6F2.2050709@canonical.com>
Date: Wed, 06 Feb 2013 18:27:46 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        pkondeti@codeaurora.org, Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
References: <Pine.LNX.4.44L0.1302041702590.1756-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1302041702590.1756-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 05:04 PM, Alan Stern wrote:
> On Fri, 1 Feb 2013, Joseph Salisbury wrote:
>
>> Hi Alan,
>>
>> There is a tar file[0] attached to the bug report[1].  The tar file
>> contains a few examples of failed and successful recording attempts
>> while collecting usbmon traces.  There is a readme.txt file available
>> after extracting the files.
>>
>> The bug reporter states that only the first recording after boot fails.
>> Subsequent recordings succeed will succeed.
>>
>> Thanks again for reviewing this, Alan.  Just let me know if you would
>> like any additional data or testing.
>>
>> Thanks,
>>
>> Joe
>>
>> [0]
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733/+attachment/3510887/+files/usbmon-1088733.tar.gz
>> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733
> I have replied to the original report at bugs.launchpad.net with a
> diagnostic patch.  Maybe it will help indicate what's going wrong.
>
> Alan Stern
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Hi Alan,

The bug reporter collected some data[0] using your diagnostic patch.

Thanks again for all your help.

Joe


[0] 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733/+attachment/3516533/+files/usbmon-diag-1088733.tar.gz


