Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3HADtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:49:31 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49474 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3HADta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:49:30 -0400
Message-ID: <51F9DAC5.2000106@felipetonello.com>
Date: Wed, 31 Jul 2013 20:49:25 -0700
From: Felipe Ferreri Tonello <eu@felipetonello.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com> <1374863133-6745-2-git-send-email-eu@felipetonello.com> <20130726185458.GX9858@sirena.org.uk> <CAGrhNMy7qZ8CbAjFX5Gv8OqYkit+Eqzr2zZTYXeQ-cNO22+pTQ@mail.gmail.com> <20130726224813.GB9858@sirena.org.uk> <CAGrhNMwGdMwhd5L2gGxQ=N=8nFk4L5txYmhEtLBVcFj-Etphnw@mail.gmail.com> <20130727122524.GH9858@sirena.org.uk> <s5hfvuxfu5b.wl%tiwai@suse.de>
In-Reply-To: <s5hfvuxfu5b.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On 07/29/2013 05:05 AM, Takashi Iwai wrote:
> At Sat, 27 Jul 2013 13:25:24 +0100,
> Mark Brown wrote:
>>
>> On Fri, Jul 26, 2013 at 04:13:40PM -0700, Felipe Tonello wrote:
>>> On Fri, Jul 26, 2013 at 3:48 PM, Mark Brown <broonie@kernel.org> wrote:
>>
>>>>>> What I'd expect to happen here is that for multi function jacks we
>>>>>> create a control per function if the controls are valid.
>>
>>> Ok, so the idea is just to change the control to type integer instead
>>> of boolean, right?
>>> Because as you say, the user will be able to check the type of jack
>>> based on the status value, right?
>>
>> It might be more idiomatic and more compatible with userspace to create
>> multiple controls for the jack, there was some discussion of this in the
>> past I think but I can't remember the result.
>
> I also forget the end result :)
>
> Another option would be to make an enum control, but multiple boolean
> controls are easier in the end.  The headset controls of HD-audio are
> represented in that way, too (because HD-audio specification can't
> tell better).

Yes. Thanks for the comment.

Felipe Tonello
