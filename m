Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaGBIJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:09:44 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62253 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaGBIJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:09:40 -0400
Message-ID: <53B3BE3E.3080802@suse.cz>
Date: Wed, 02 Jul 2014 10:09:34 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: stable@vger.kernel.org, linux@roeck-us.net, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/181] 3.12.24-stable review
References: <cover.1404128997.git.jslaby@suse.cz> <20140701235359.GJ4453@dastard>
In-Reply-To: <20140701235359.GJ4453@dastard>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 01:53 AM, Dave Chinner wrote:
> On Mon, Jun 30, 2014 at 01:51:22PM +0200, Jiri Slaby wrote:
>> This is the start of the stable review cycle for the 3.12.24 release.
>> There are 181 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> .....
>> Dave Chinner (3):
>>   xfs: prevent deadlock trying to cover an active log
>>   xfs: prevent stack overflows from page cache allocation
>>   xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
> 
> None of the XFS patches you're backporting were marked for stable.
> What criteria did you choose them by, and how are you testing the
> result?

Hi Dave,

these patches are in SUSE's enterprise linux based on 3.12. So I picked
them from there. Testing is covered by our QA, but of course, with some
additional patches on the top of them which do not satisfy the stable
rules (because they add features).

> Randomly picked XFS backports have a nasty habit of causing
> regressions, and it's always me that is on the pointy end of having
> to triage problems users report with those backports...

Despite the patches fix real problems, if you prefer me not to take such
patches, I will drop them and will apply no more.

thanks,
-- 
js
suse labs
