Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab3BXV13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 16:27:29 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:34446 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354Ab3BXV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 16:27:27 -0500
Message-ID: <512A85BB.8070500@suse.cz>
Date: Sun, 24 Feb 2013 22:27:23 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Daniel J Blueman <daniel@numascale-asia.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: kswapd craziness round 2
References: <5121C7AF.2090803@numascale-asia.com> <CAJd=RBArPT8YowhLuE8YVGNfH7G-xXTOjSyDgdV2RsatL-9m+Q@mail.gmail.com> <51254AD2.7000906@suse.cz> <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
In-Reply-To: <CAJd=RBCiYof5rRVK+62OFMw+5F=5rS=qxRYF+OHpuRz895bn4w@mail.gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 01:07 PM, Hillf Danton wrote:
> On Thu, Feb 21, 2013 at 6:14 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>
>>> Does Ingo's revert help? https://lkml.org/lkml/2013/2/15/168
>>
>> Not at all...
>>
> Then mind taking a try?

Applied now, I'll report in a week or so as it needs a couple of days of
uptime to occur.

thanks,
-- 
js
suse labs
