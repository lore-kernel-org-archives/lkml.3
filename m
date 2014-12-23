Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaLWEQm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:16:42 -0500
Received: from omr.mail.isx.net.nz ([111.65.230.130]:37538 "EHLO
	omr.mail.isx.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaLWEQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:16:41 -0500
Message-ID: <5498ECA5.2050802@blennerhassett.gen.nz>
Date: Tue, 23 Dec 2014 17:16:37 +1300
From: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sound: pci: asihpi: hpifunc.c: Remove some unused functions
References: <1419180627-8986-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <54974A66.8010209@blennerhassett.gen.nz> <CAFo99gazBQ=dYJX=2484m0ZydTZ9FRetPHdj=sgAVogtsxzfvQ@mail.gmail.com>
In-Reply-To: <CAFo99gazBQ=dYJX=2484m0ZydTZ9FRetPHdj=sgAVogtsxzfvQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/12/14 10:41, Rickard Strandqvist wrote:
> Hi Eliot!
> 
> This is one of the largest remove patches I made.
> Is it just one function you disagree with?

Yes.  If you generate the patch against for-next branch I guess that
function will not be removed because it is used by the new code.
> 
> Then I obviously send a new Patch!
> Will be busy few days, but then I send a new one.
> 
> Kind regards
> Rickard Strandqvist
> 
> 
> 2014-12-21 23:32 GMT+01:00 Eliot Blennerhassett <eliot@blennerhassett.gen.nz>:
>> On 22/12/14 05:50, Rickard Strandqvist wrote:
>>> Removes some functions that are not used anywhere:
>>
>> NAK - because  hpi_adapter_set_property() is now used in for-next branch
>> of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
>>
>> Otherwise I have no problem with the patch.


-- 
Eliot
