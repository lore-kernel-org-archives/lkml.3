Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3BLJnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 04:43:53 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:60387 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3BLJnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 04:43:52 -0500
Message-ID: <511A0EA3.2080506@lab.ntt.co.jp>
Date: Tue, 12 Feb 2013 18:42:59 +0900
From: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ALSA: hda - no-primary-hp is a quirk for model ALC889
 not ALC882
References: <1360655264.13766.2.camel@nexus.lab.ntt.co.jp> <1360655656.13766.6.camel@nexus.lab.ntt.co.jp> <s5ha9r9opap.wl%tiwai@suse.de>
In-Reply-To: <s5ha9r9opap.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/02/12 18:27, Takashi Iwai wrote:
> At Tue, 12 Feb 2013 16:54:16 +0900,
> Fernando Luis Vázquez Cao wrote:
>> Substitute ALC889 for ALC882 in macro and function names.
>>
>> Cc: stable@vger.kernel.org
>> Cc: alsa-devel@alsa-project.org
>> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> This fixup can work generically to all ALC882 variants, including
> ALC889.  Unless you are really sure that this must be used exclusively
> only for ALC889, no reason to change the prefix.

Thank you for applying patches 1 and 2 (I agree that
the second patch is not needed for stable).

Regarding this patch, I am not completely sure whether
this issue is ALC889 specific so we probably shouldn't
apply it as you say.

Regards,
Fernando
