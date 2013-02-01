Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3BAWxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:53:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab3BAWxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:53:30 -0500
Message-ID: <510C4700.5030304@canonical.com>
Date: Fri, 01 Feb 2013 17:51:44 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        pkondeti@codeaurora.org, Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
References: <Pine.LNX.4.44L0.1301171353330.1339-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301171353330.1339-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:56 PM, Alan Stern wrote:
> On Thu, 17 Jan 2013, Joseph Salisbury wrote:
>
>> Hello,
>>
>> Please consider reverting commit
>> 3d037774b42ed677f699b1dce7d548d55f4e4c2b in mainline as well as in the
>> current stable releases.  It was included upstream as of v3.6-rc6.  This
>> commit introduced a regression, described in the following bug report:
>>
>> http://bugs.launchpad.net/bugs/1088733
>>
>> Reverting commit 3d037774b42ed677f699b1dce7d548d55f4e4c2b in the v3.2
>> kernel has been confirmed to resolve the aforementioned bug.
> I do not want to revert this commit without first understanding what is
> going wrong.  Please ask the reporter to post usbmon traces showing
> what happens in both a failed and a successful recording attempt.
>
> Alan Stern
>
Hi Alan,

There is a tar file[0] attached to the bug report[1].  The tar file 
contains a few examples of failed and successful recording attempts 
while collecting usbmon traces.  There is a readme.txt file available 
after extracting the files.

The bug reporter states that only the first recording after boot fails. 
Subsequent recordings succeed will succeed.

Thanks again for reviewing this, Alan.  Just let me know if you would 
like any additional data or testing.

Thanks,

Joe

[0] 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733/+attachment/3510887/+files/usbmon-1088733.tar.gz
[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733
