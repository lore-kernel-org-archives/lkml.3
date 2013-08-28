Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab3H1RQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:16:05 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35022 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3H1RQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:16:03 -0400
Message-ID: <521E3044.80109@gmail.com>
Date: Wed, 28 Aug 2013 22:45:48 +0530
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] xHCI: Fixing xhci_readl definition and function call
References: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com> <20130828071304.GO6329@mwanda> <521E1292.5060709@gmail.com> <20130828170137.GB26483@xanatos>
In-Reply-To: <20130828170137.GB26483@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 August 2013 10:31 PM, Sarah Sharp wrote:
> On Wed, Aug 28, 2013 at 08:39:06PM +0530, Kumar Gaurav wrote:
>> On Wednesday 28 August 2013 12:43 PM, Dan Carpenter wrote:
>>> On Mon, Aug 26, 2013 at 07:38:57AM +0530, Kumar Gaurav wrote:
>> I've started cloning linux-next and as it's not applying on
>> linux-next, I'll try it on linux-next (once i cloned it)  and will
>> send again.
> Yeah, this doesn't apply against Greg's usb-next tree, so I can't take
> it.  If you're sending non-bug fixes in, you need to base your patches
> against that tree, or linux-next.
>
> Sarah Sharp
I'm trying against linux-git as
     cat 0027-xHCI-Fixing-xhci_readl-definition-and-function-call.patch| 
patch
and then after i enter the required file (drivers/usb/host/xhci-dbg.c).
it's giving me  message

File to patch: drivers/usb/host/xhci-dbg.c
patching file drivers/usb/host/xhci-dbg.c
can't find file to patch at input line 180
Perhaps you should have used the -p or --strip option?
The text leading up to this was:

but when i saw the file i found changes are applied there.

I had made the patch using git format-patch. what could be the possible 
reason behind this issue or am i mistaking somewhere?


Regards
Kumar Gaurav



