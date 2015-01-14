Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbbANHxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:53:09 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:3663 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbbANHxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:53:05 -0500
Message-ID: <54B6205C.7060608@imgtec.com>
Date: Wed, 14 Jan 2015 07:53:00 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Vinod Koul <vinod.koul@intel.com>, <alsa-devel@alsa-project.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, "Takashi Iwai" <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ALSA: ASoC: soc-compress.c: fix NULL dereference
References: <1421147933-21802-1-git-send-email-qais.yousef@imgtec.com> <20150113145931.GD3085@intel.com> <54B536BA.3070001@imgtec.com> <20150113162004.GR4160@sirena.org.uk>
In-Reply-To: <20150113162004.GR4160@sirena.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 04:20 PM, Mark Brown wrote:
> On Tue, Jan 13, 2015 at 03:16:10PM +0000, Qais Yousef wrote:
>> On 01/13/2015 02:59 PM, Vinod Koul wrote:
>>>> being NULL, hence when trying to set rtd a few lines below we get an oops.
>>> It is a good practice to add the oops here
>> Will this really be helpful? I think it'll be more clutter (the backtrace on
>> metag arch is not great):
> It's better in general to leave it out unless it's adding something (for
> example sometimes the particular call path is important) and even there
> edit it down to relevant details - the splat from the full oops normally
> overwhelms the commit message.

I think the commit message explains what's going. So unless Vinod 
insists I'll send v3 with the other 2 requested fixes.

Thanks for the review!
