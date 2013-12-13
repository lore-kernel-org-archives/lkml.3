Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3LMTIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:08:31 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:53729 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3LMTIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:08:30 -0500
Message-ID: <52AB5B2A.4040508@linux.com>
Date: Fri, 13 Dec 2013 20:08:26 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] eisa: call put_device if device_register fails
References: <1386959996-7958-1-git-send-email-levex@linux.com> <1386959996-7958-3-git-send-email-levex@linux.com> <20131213190400.GB6746@google.com>
In-Reply-To: <20131213190400.GB6746@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 08:04 PM, Bjorn Helgaas wrote:
> On Fri, Dec 13, 2013 at 07:39:54PM +0100, Levente Kurusa wrote:
>> We need to give up the last reference to edev->dev, so
>> we need to call put_device().
>>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Signed-off-by: Levente Kurusa <levex@linux.com>
> 
> I applied this and will push it through my PCI tree, since I don't think
> anybody really takes care of EISA these days.
> 
> I looked at other callers of device_register(), and most of them look like
> they have the same problem.  Can you fix the others, too?  This patch says
> "2/4", so maybe you already are, but I can't find the other patches in the
> series.

Yes, the patchset didn't hit LKML due to me being a noob with git-send-email. :-(

I will fix them, just sent this to verify that I am doing it right. :-)

Thanks for applying!

-- 
Regards,
Levente Kurusa
