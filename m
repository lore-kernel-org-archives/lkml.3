Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936099Ab3DJIk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:40:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45280 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab3DJIk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:40:57 -0400
Message-ID: <51652597.4000102@arm.com>
Date: Wed, 10 Apr 2013 09:40:55 +0100
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?windows-1252?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH v2 1/7] staging: android: binder: clean-up uint32_t types
References: <1365501657-4213-1-git-send-email-serban.constantinescu@arm.com> <1365501657-4213-2-git-send-email-serban.constantinescu@arm.com> <CAMP5XgdPQeKBXCV5XHqkRi6NsJAhF5NdV_dEf_7gv2=GWs3v3w@mail.gmail.com>
In-Reply-To: <CAMP5XgdPQeKBXCV5XHqkRi6NsJAhF5NdV_dEf_7gv2=GWs3v3w@mail.gmail.com>
X-OriginalArrivalTime: 10 Apr 2013 08:40:54.0825 (UTC) FILETIME=[1D651190:01CE35C7]
X-MC-Unique: 113041009405501301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/13 01:11, Arve Hjønnevåg wrote:
> On Tue, Apr 9, 2013 at 3:00 AM, Serban Constantinescu
> <serban.constantinescu@arm.com> wrote:
>> uint32_t types are used inconsistently throughout the driver. This patch
>> replaces "uint32_t" types with "unsigned int" ones.
>>
>
> I don't like this change. You fix the header in a later patch to use
> explicit sizes, so it does not make sense to do the opposite here.

As mentioned before we do not need this change. I will drop it from the 
patch set.

Thanks,
Serban

