Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbbANIBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:01:03 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:65496 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269AbbANIBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:01:00 -0500
Message-ID: <54B62239.1020009@imgtec.com>
Date: Wed, 14 Jan 2015 08:00:57 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Vinod Koul <vinod.koul@intel.com>, <alsa-devel@alsa-project.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "Jaroslav Kysela" <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ALSA: ASoC: soc-compress.c: fix NULL dereference
References: <1421147933-21802-1-git-send-email-qais.yousef@imgtec.com> <20150113145931.GD3085@intel.com> <54B536BA.3070001@imgtec.com> <BB5B134B-1BFA-4F77-A8CC-45C0137EBF57@imgtec.com>
In-Reply-To: <BB5B134B-1BFA-4F77-A8CC-45C0137EBF57@imgtec.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 05:21 PM, James Hogan wrote:
> On 13 January 2015 15:16:10 GMT+00:00, Qais Yousef <qais.yousef@imgtec.com> wrote:
>>
>> Will this really be helpful? I think it'll be more clutter (the
>> backtrace on metag arch is not great):
> I suspect you don't have frame pointers enabled in your kernel config. That should improve the meaningfulness of the backtrace.
>
>

I forgot about this option. Thanks.
