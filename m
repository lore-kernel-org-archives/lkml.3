Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3I3LiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:38:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3I3Lh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:37:58 -0400
Message-ID: <52496294.80403@canonical.com>
Date: Mon, 30 Sep 2013 13:37:56 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 026/104] ALSA: hda - hdmi: Refactor hdmi_eld into parsed_hdmi_eld
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>	<1380535881-9239-27-git-send-email-luis.henriques@canonical.com>	<52495273.8050308@canonical.com> <87r4c61s5h.fsf@canonical.com>
In-Reply-To: <87r4c61s5h.fsf@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 01:10 PM, Luis Henriques wrote:
> Hi David,
> 
> David Henningsson <david.henningsson@canonical.com> writes:
> 
>> On 09/30/2013 12:10 PM, Luis Henriques wrote:
>>> 3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: David Henningsson <david.henningsson@canonical.com>
>>>
>>> commit 1613d6b46b433f07f1d2703e4bd102802dcd75a4 upstream.
>>>
>>> For better readability, the information that is parsed out of the
>>> ELD data is now put into a separate parsed_hdmi_eld struct.
>>>
>>> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>> [ luis: 3.5.y-prereq for:
>>>   18e3918 ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA ]
>>
>> I don't think this is really a prereq. Sorting out the fuzz in
>> hdmi_channel_allocation seems quite trivial to me, so I would suggest
>> doing so instead.
>>
>> If you do go ahead and backport this patch, a bit of testing wouldn't
>> hurt: this patch was part of a bigger patch set, and I don't think
>> anyone tested just this one without the bigger set.
> 
> Ok, I agree with you and I'm dropping this patch from the 3.5 kernel.
> Also, I'm replacing
> 
>  [PATCH 027/104] ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA
> 
> with the patch below.  Are you Ok with this?

Yes, I think it looks good.

> (btw, thank you for your review!)

Thanks for the stable backport :-)


-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
