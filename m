Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab3EGXWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:22:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33189 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3EGXWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:22:54 -0400
Message-ID: <51898CC7.5090704@zytor.com>
Date: Tue, 07 May 2013 16:22:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Kevin Cernekee <cernekee@gmail.com>, linux-input@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lenovo Yoga 13 touchpad regression
References: <5188905A.4020703@zytor.com> <51894B6F.9040108@zytor.com> <51898810.4090301@zytor.com> <3470196.LXVkxnnbGR@dtor-d630.eng.vmware.com>
In-Reply-To: <3470196.LXVkxnnbGR@dtor-d630.eng.vmware.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 04:19 PM, Dmitry Torokhov wrote:
> On Tuesday, May 07, 2013 04:02:40 PM H. Peter Anvin wrote:
>> On 05/07/2013 11:43 AM, H. Peter Anvin wrote:
>>> What is really bizarre is that some time today the touchpad
>>> spontaneously started to work.  However, after a reboot it no longer
>>> worked again.  This is on 3.8.11.  The keycode spewage continued, however.
>>
>> OK, "spontaneously" seems to mean "after going in and out of suspend to
>> RAM".
> 
> Does i8042.reset help by any chance?
> 

No.

	-hpa
