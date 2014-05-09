Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaEIRN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:13:56 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4459 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbaEIRNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:13:55 -0400
Message-ID: <536D0CA4.60209@xs4all.nl>
Date: Fri, 09 May 2014 19:13:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
CC: Dan Carpenter <dan.carpenter@oracle.com>, hans.verkuil@cisco.com,
        m.chehab@samsung.com, ext-eero.nurkkala@nokia.com,
        nils.faerber@kernelconcepts.de, joni.lapilainen@gmail.com,
        freemangordon@abv.bg, sre@ring0.de, Greg KH <greg@kroah.com>,
        linux-media@vger.kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2] radio-bcm2048.c: fix wrong overflow check
References: <20140422125726.GA30238@mwanda> <alpine.LNX.2.00.1405051534090.3969@pobox.suse.cz> <201405091810.18289@pali>
In-Reply-To: <201405091810.18289@pali>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 06:10 PM, Pali Rohár wrote:
> On Monday 05 May 2014 15:34:29 Jiri Kosina wrote:
>> On Tue, 22 Apr 2014, Dan Carpenter wrote:
>>> From: Pali Rohár <pali.rohar@gmail.com>
>>>
>>> This patch fixes an off by one check in
>>> bcm2048_set_region().
>>>
>>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
>>> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> ---
>>> v2: Send it to the correct list.  Re-work the changelog.
>>>
>>> This patch has been floating around for four months but
>>> Pavel and Pali are knuckle-heads and don't know how to use
>>> get_maintainer.pl so they never send it to linux-media.
>>>
>>> Also Pali doesn't give reporter credit and Pavel steals
>>> authorship credit.
>>>
>>> Also when you try explain to them about how to send patches
>>> correctly they complain that they have been trying but it
>>> is too much work so now I have to do it.  During the past
>>> four months thousands of other people have been able to
>>> send patches in the correct format to the correct list but
>>> it is too difficult for Pavel and Pali...  *sigh*.
>>
>> Seems like it's not in linux-next as of today, so I am taking
>> it now. Thanks,
> 
> I still do not see this patch in torvalds branch... So what is 
> needed to include this security buffer overflow patch into 
> mainline & stable kernels?
> 

Today I collected a pile of pending patches including this one and
posted a pull request on the linux-media mailinglist. Once Mauro picks
it up it will appear in our tree and then linux-next. He's been
travelling for the past two weeks, so he'll have a sizable backlog.

Just be patient, it's not forgotten.

Regards,

	Hans
