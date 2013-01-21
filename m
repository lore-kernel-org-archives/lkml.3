Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3AUOKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:10:40 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:54183 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3AUOKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:10:36 -0500
Message-ID: <50FD4C4B.9080507@xs4all.nl>
Date: Mon, 21 Jan 2013 15:10:19 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic> <20130120115755.GO25591@8bytes.org> <20130121130942.GB4445@pd.tnic>
In-Reply-To: <20130121130942.GB4445@pd.tnic>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-21 14:09, Borislav Petkov wrote:
>> Let's see what happens...
> 
> Btw, while we're at it, here's some more h0rkage from my PD box:
> 
> [    0.220022] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> [    0.220078] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> [    0.220132] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
> [    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)

I have:

# dmesg|grep -i amd-vi
[    1.125636] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
[    1.125701] AMD-Vi:  Extended features:  PreF PPR GT IA
[    1.131725] AMD-Vi: Lazy IO/TLB flushing enabled


Is that 'OK'?

Udo


