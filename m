Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaI3G7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:59:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51182 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaI3G7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:59:37 -0400
Message-ID: <542A54D6.8070906@suse.com>
Date: Tue, 30 Sep 2014 08:59:34 +0200
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>
CC: xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/xen-scsiback: Need go to fail after xenbus_dev_error()
References: <5425967F.7020002@gmail.com> <5428E0ED.1050107@suse.com>	<54293742020000780003A48A@mail.emea.novell.com>	<54292707.90008@gmail.com> <542927C3.8010204@suse.com> <54292D6E.4060903@gmail.com> <54296559.5020301@citrix.com> <542A4E79.4020109@gmail.com>
In-Reply-To: <542A4E79.4020109@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2014 08:32 AM, Chen Gang wrote:
> On 9/29/14 21:57, David Vrabel wrote:
>> On 29/09/14 10:59, Chen Gang wrote:
>>>
>>>
>>> If no any additional reply within 2 days, I shall send patch v2 for it:
>>>
>>>    "use dev_warn() instead of xenbus_dev_error() and remove 'fail' code block"
>>
>> I think this driver is fine as-is and does not need any changes.
>>
>
> OK, at least, at present, it is not a bug (will cause any issue).
>
> But for me, xenbus_dev_error() seems for printing generic errors,
> dev_warn() is more suitable than it.

I'm unbiased regarding this one.

>
> And 'fail' code block is useless now, need be removed, too (which will
> let compiler report warning).

This should be part of the patch making the 'fail' block useless.


Juergen

