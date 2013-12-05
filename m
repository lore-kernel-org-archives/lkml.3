Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3LEHxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:53:47 -0500
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2089 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3LEHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:53:45 -0500
Message-ID: <52A030BE.7040709@xs4all.nl>
Date: Thu, 05 Dec 2013 08:52:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
        Nils Faerber <nils.faerber@kernelconcepts.de>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Subject: Re: [PATCH] media: Add BCM2048 radio driver
References: <1381847218-8408-1-git-send-email-pali.rohar@gmail.com> <201310262245.03279@pali> <52778780.6060802@xs4all.nl> <201312022151.07599@pali>
In-Reply-To: <201312022151.07599@pali>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 09:51 PM, Pali Rohár wrote:
> On Monday 04 November 2013 12:39:44 Hans Verkuil wrote:
>> Hi Pali,
>>
>> On 10/26/2013 10:45 PM, Pali Rohár wrote:
>>> On Saturday 26 October 2013 22:22:09 Hans Verkuil wrote:
>>>>> Hans, so can it be added to drivers/staging/media tree?
>>>>
>>>> Yes, that is an option. It's up to you to decide what you
>>>> want. Note that if no cleanup work is done on the staging
>>>> driver for a long time, then it can be removed again.
>>>>
>>>> Regards,
>>>>
>>>>     Hans
>>>
>>> Ok, so if you can add it to staging tree. When driver will
>>> be in mainline other developers can look at it too. Now
>>> when driver is hidden, nobody know where to find it... You
>>> can see how upstream development for Nokia N900 HW going
>>> on: http://elinux.org/N900
>>
>> Please check my tree:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/h
>> eads/bcm
>>
>> If you're OK, then I'll queue it for 3.14 (it's too late for
>> 3.13).
>>
>> Regards,
>>
>> 	Hans
> 
> Hi, sorry for late reply. I looked into your tree and difference 
> is that you only removed "linux/slab.h" include. So it it is not 
> needed, then it is OK.

I *added* slab.h :-)

Anyway, I've posted the pull request. Please note, if you want to avoid
having this driver be removed again in the future, then you (or someone else)
should work on addressing the issues in the TODO file I added.

Regards,

	Hans
