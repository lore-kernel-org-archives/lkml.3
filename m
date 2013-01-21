Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3AUPeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:34:20 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:55519 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3AUPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:34:20 -0500
Message-ID: <50FD5FEC.7010501@xs4all.nl>
Date: Mon, 21 Jan 2013 16:34:04 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic> <20130120115755.GO25591@8bytes.org> <20130121130942.GB4445@pd.tnic> <20130121151000.GR25591@8bytes.org> <20130121153220.GF4445@pd.tnic>
In-Reply-To: <20130121153220.GF4445@pd.tnic>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-21 16:32, Borislav Petkov wrote:
>>> [    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
>>
>> Yes, that are BIOS bugs too that prevent interrupt remapping to function
>> reliably. But the good thing is that these bugs can be detected easily
>> to enable a workaround :-)
> 
> Well, I'm all ready to test stuff since this is the latest ASUS BIOS
> and I'm not even going to ask them to fix it there based on previous
> experience with them :-).

I too am ready to test but the Gigabyte case is still open and unanswered.

Udo

