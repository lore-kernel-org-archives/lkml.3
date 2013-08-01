Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab3HADw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:52:56 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39428 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3HADwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:52:55 -0400
Message-ID: <51F9DB94.1090906@felipetonello.com>
Date: Wed, 31 Jul 2013 20:52:52 -0700
From: Felipe Ferreri Tonello <eu@felipetonello.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH v2 1/3] ALSA: Added jack detection kcontrol support
References: <1374878713-11922-1-git-send-email-eu@felipetonello.com> <1374878713-11922-2-git-send-email-eu@felipetonello.com> <s5hli4pe9ds.wl%tiwai@suse.de>
In-Reply-To: <s5hli4pe9ds.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 07:19 AM, Takashi Iwai wrote:
> At Fri, 26 Jul 2013 15:45:11 -0700,
> Felipe F. Tonello wrote:
>>
>> From: "Felipe F. Tonello" <eu@felipetonello.com>
>>
>> This patch adds jack support for alsa kcontrol.
>>
>> This support is necessary since the new kcontrol is used by user-space
>> daemons, such as PulseAudio(>=2.0), to do jack detection.)
>>
>> Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
>
> This patch breaks the build.

I'm planing to send a v3 in few days.

Felipe Tonello

