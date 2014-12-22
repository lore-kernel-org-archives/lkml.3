Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbaLVVlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 16:41:52 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:38850 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaLVVlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 16:41:51 -0500
MIME-Version: 1.0
In-Reply-To: <54974A66.8010209@blennerhassett.gen.nz>
References: <1419180627-8986-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <54974A66.8010209@blennerhassett.gen.nz>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 22 Dec 2014 22:41:29 +0100
Message-ID: <CAFo99gazBQ=dYJX=2484m0ZydTZ9FRetPHdj=sgAVogtsxzfvQ@mail.gmail.com>
Subject: Re: [PATCH] sound: pci: asihpi: hpifunc.c: Remove some unused functions
To: Eliot Blennerhassett <eliot@blennerhassett.gen.nz>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eliot!

This is one of the largest remove patches I made.
Is it just one function you disagree with?

Then I obviously send a new Patch!
Will be busy few days, but then I send a new one.

Kind regards
Rickard Strandqvist


2014-12-21 23:32 GMT+01:00 Eliot Blennerhassett <eliot@blennerhassett.gen.nz>:
> On 22/12/14 05:50, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>
> NAK - because  hpi_adapter_set_property() is now used in for-next branch
> of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound.git
>
> Otherwise I have no problem with the patch.
