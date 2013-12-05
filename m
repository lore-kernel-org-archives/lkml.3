Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3LEXno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:43:44 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:36824 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3LEXnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:43:41 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: "'open list'" <linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <gregkh@linuxfoundation.org>
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com> <yq1iovclm0m.fsf@sermon.lab.mkp.net> <00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com> <yq1d2lkllek.fsf@sermon.lab.mkp.net> <010b01ceec84$27643580$762ca080$@lucidpixels.com>
In-Reply-To: <010b01ceec84$27643580$762ca080$@lucidpixels.com>
Subject: RE: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Thu, 5 Dec 2013 18:43:39 -0500
Message-ID: <018b01cef213$d34d1df0$79e759d0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIRpMQ5yoPFWdrjnTAKydtw81oUOQGvynbaASKfOScCoiRwNAIp0YgrmYPpOnA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, November 28, 2013 8:13 AM
> 
> 
> Martin>	http://marc.info/?l=linux-scsi&m=138252394614920&w=2
> 
> Justin> Awesome, thank you!  This patch is over a month old, do you know
> Justin> if is currently in mainline?
> 
> Nope. - James?
> 
> Could it possibly get added to 3.12.x -stable as well? I've patched
against
> 3.12.0 for now -- I'll let you know if there are any issues-- so far so
> good, thanks again.
> 
> Justin.

Update:
System uptime with the patch is 7+ days under extensive load at times and
I've had no issues to date.
I just checked the current linux git repo (3.13-rc2) and found this patch
has not been included.

Please advise if any further testing or validation needs to be completed to
help get this into -stable/-mainline.

Justin.



