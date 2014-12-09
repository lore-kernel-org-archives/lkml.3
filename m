Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaLITIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:08:39 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36132 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaLITIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:08:38 -0500
Message-ID: <548748B3.1020402@lwfinger.net>
Date: Tue, 09 Dec 2014 13:08:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2014-12-03
References: <20141203203432.GF2896@tuxdriver.com> <20141209.133602.1849817956610567109.davem@davemloft.net>
In-Reply-To: <20141209.133602.1849817956610567109.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 12:36 PM, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 3 Dec 2014 15:34:33 -0500
>
>> One last(?) batch of fixes hoping to make 3.18...
>>
>> In this episode, we have another trio of rtlwifi fixes
>> repairing a little more damage from the major update of the
>> rtlwifi-family of drivers.  These editing mistakes caused some
>> memory corruption and missed a flag critical to proper interrupt
>> handling.  Together, these fix the kernel regression reported at
>> https://bugzilla.kernel.org/show_bug.cgi?id=88951 by Catalin Iacob.
>>
>> Please let me know if there are problems!
>
> Unfortunately, this did not make it for 3.18, but I've pulled it into my
> 'net' tree which I'll merge into 'net-next' for the merge window.

I knew those were very late. Thanks for letting us know that they did not make 
it in time. I will watch for them to reach mainline, and then send a message 
requesting that they be backported to 3.18.X.

Larry


