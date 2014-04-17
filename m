Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422726AbaDQNdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:33:16 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59022 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaDQNdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:33:14 -0400
Message-ID: <534FD817.2090108@acm.org>
Date: Thu, 17 Apr 2014 08:33:11 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Torsten Duwe <duwe@lst.de>
CC: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org, Tomas Cech <tcech@suse.cz>,
        openipmi-developer@lists.sourceforge.net,
        Rocky Craig <rocky.craig@hp.com>
Subject: Re: [PATCH 1/1] Char: ipmi_bt_sm, fix infinite loop
References: <1393323294-11423-1-git-send-email-jslaby@suse.cz> <530D1021.1050402@acm.org> <533023F5.40909@suse.cz> <533080AB.9080702@acm.org> <20140417132142.GA7976@lst.de>
In-Reply-To: <20140417132142.GA7976@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 08:21 AM, Torsten Duwe wrote:
> On Mon, Mar 24, 2014 at 01:59:55PM -0500, Corey Minyard wrote:
>> On 03/24/2014 07:24 AM, Jiri Slaby wrote:
>>> On 02/25/2014 10:50 PM, Corey Minyard wrote:
>>>> Looks right to me.  Rocky, copying you in case there's an issue with this.
>>> Hi,
>>>
>>> any updates here, I don't see it in the -next tree yet?
>>>
>>> Thanks.
>> I normally don't submit to the -next tree because there is little to
>> integrate with in the IPMI driver.  Maybe it would be a good idea to
>> start, though.  If you want to, I can.
> Yes, please! :)
> And you may want to send bugfixes towards -stable.

I will definitely do that.

Thanks,

-corey
