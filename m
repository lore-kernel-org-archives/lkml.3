Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbbACS5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 13:57:11 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35807 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbbACS5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 13:57:07 -0500
Message-ID: <54A83B80.1020508@ti.com>
Date: Sat, 03 Jan 2015 12:57:04 -0600
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org
CC: edubezval@gmail.com, rui.zhang@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cleanup ti-soc-thermal
References: <20150103111904.GA11545@amd> <20150103174804.GA20341@kahuna> <20150103185130.GA5950@amd>
In-Reply-To: <20150103185130.GA5950@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2015 12:51 PM, Pavel Machek wrote:
> On Sat 2015-01-03 11:48:04, Nishanth Menon wrote:
>> On 12:19-20150103, Pavel Machek wrote:
>>> Simplify code by removing goto's where they point to simple return.
>>>
>>> Avoid confusing |= on error values.
>>
>> Please split these up into chunks of related changes. there is white
>> space and quiet a few other changes all mixed in.
>
> Do you believe that the patch is too big to be understood? I don't
> think it is.
>
> It is four screens, and it is pretty obvious it does not change any
> code.

It basic patch generation stuff - where you are being nice to the 
reviewer. When you are doing functional changes, at least drop out or at 
the very least mention that there are white space changes in your patch 
submission.

I dont care too much to review stuff where I have to look at multiple 
changes in a single patch - trivial or not. Sorry.. just a waste of my time.

--
Regards,
Nishanth Menon

