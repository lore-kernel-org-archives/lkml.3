Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3F1BFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:05:13 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9285 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3F1BFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:05:11 -0400
Message-ID: <51CCE13F.6070009@hp.com>
Date: Fri, 28 Jun 2013 09:05:03 +0800
From: "Li, Zhen-Hua (USL-China)" <zhen-hual@hp.com>
Organization: USL-China
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
References: <Pine.LNX.4.44L0.1306271150330.1167-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306271150330.1167-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a problem, the warning "Controller not stopped yet".
And your last patch for this problem does a wrong thing:
It prevents all HP uhci devices from auto-stop, which make HP uhci 
devices waste more
power.
This is another new problem.

I think this should be corrected, so I want to apply it.

Thanks
Zhen-Hua

On 06/27/2013 11:52 PM, Alan Stern wrote:
> On Thu, 27 Jun 2013, Li, Zhen-Hua (USL-China) wrote:
>
>> Hi Alan,
>>
>> I don't have a machine that this makes action different.
> Then why do you want to apply the patch?
>
>> No matter whether it makes different, there is one thing will never change:
>> We create a patch to FIX a problem, not to avoid a problem.
>> Only when we can not fix it, we try to avoid it.
> But in this case, there is no problem to fix or to avoid, right?  After
> all, how can there be a problem if no machines are affected?
>
> Alan Stern
>
> .
>

