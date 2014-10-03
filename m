Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaJCLDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 07:03:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaJCLDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 07:03:50 -0400
Message-ID: <542E828A.6010305@redhat.com>
Date: Fri, 03 Oct 2014 13:03:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Tommy Will <tommywill2011@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] input: alps: Reset mouse and ALPS driver immediately
 after first invalid packet
References: <1412329392-5580-1-git-send-email-pali.rohar@gmail.com> <201410031205.42927@pali> <542E780B.7030103@redhat.com> <201410031223.10608@pali>
In-Reply-To: <201410031223.10608@pali>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/03/2014 12:23 PM, Pali Rohár wrote:
> On Friday 03 October 2014 12:18:51 Hans de Goede wrote:
>>> On my E6440 machine it somehow working. When driver
>>> doing ps/2 reset keyboard, touchpad and trackstick not
>>> responding.
>>
>> Right, but I would expect that to be for only a short period
>> of time, or does the whole reset take a significant amount of
>> time ?
>>
> 
> It is one or two seconds which is OK for me.

Hmm, 1-2 seconds is quite long, not good. Lets see if the solution
we've been discussing by private mail yields better results.

Regards,

Hans
