Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbaGANk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:40:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55053 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbaGANk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:40:26 -0400
Message-ID: <53B2BA3E.1010705@gmail.com>
Date: Tue, 01 Jul 2014 15:40:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com> <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com> <20140701131026.GO32514@n2100.arm.linux.org.uk> <53B2B5E5.50502@gmail.com> <20140701133627.GP32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140701133627.GP32514@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 03:36 PM, Russell King - ARM Linux wrote:
> On Tue, Jul 01, 2014 at 03:21:41PM +0200, Sebastian Hesselbarth wrote:
>> On 07/01/2014 03:10 PM, Russell King - ARM Linux wrote:
>>> On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
>>> If you want to do this then you need to add the endpoints from the start
>>> even though the driver doesn't yet make use of them - or don't add the
>>> DT bits at all.
>>
>> If you really think that way, I definitely give up on mainline Dove and
>> SolidRun Cubox. You are /really/ proposing to wait for *all* related
>> subsystem bindings to settle before even starting to add DT support?
>
> *Sigh*.

Russell,

honestly, I am out. Feel free to take over anything you want. I
understand you are in a bad mood because you feel ignored on your
patches, but for me your attitude is unbearable and *the* reason
to step back now.

Sebastian
