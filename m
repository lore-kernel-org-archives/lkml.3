Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967542AbaLLL7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:59:44 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:59576 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966268AbaLLL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:59:42 -0500
Message-ID: <548AD8AB.4090400@hurleysoftware.com>
Date: Fri, 12 Dec 2014 06:59:39 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] TTY: add slave driver to power-on device via a regulator.
References: <20141211214801.4127.93914.stgit@notabene.brown>	<20141211215944.4127.4186.stgit@notabene.brown>	<548A29A4.7060908@hurleysoftware.com> <20141212162714.3a2378df@notabene.brown>
In-Reply-To: <20141212162714.3a2378df@notabene.brown>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014 12:27 AM, NeilBrown wrote:
> On Thu, 11 Dec 2014 18:32:52 -0500 Peter Hurley <peter@hurleysoftware.com>
> wrote:
> 
>> On 12/11/2014 04:59 PM, NeilBrown wrote:
>>> The regulator is identified in devicetree as 'vdd-supply'
>>>
>>> Signed-off-by: NeilBrown <neilb@suse.de>
>>
>> tty_* is only for tty core functions/data.
> 
> I think you are just objecting to the function and type names - is that
> correct?

Yeah, exactly.

>  I suspect I can come up with something different.

Thanks.
