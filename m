Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3ATLxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:53:13 -0500
Received: from pindarots.xs4all.nl ([80.101.128.228]:46782 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3ATLxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:53:12 -0500
Message-ID: <50FBDA9A.3000101@xs4all.nl>
Date: Sun, 20 Jan 2013 12:52:58 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
References: <50FBC7EF.6040207@xs4all.nl> <20130120103652.GB16800@pd.tnic> <50FBC994.8020409@xs4all.nl> <20130120111920.GL25591@8bytes.org> <50FBD413.1000406@xs4all.nl> <20130120114011.GN25591@8bytes.org> <20130120114828.GB16519@pd.tnic>
In-Reply-To: <20130120114828.GB16519@pd.tnic>
X-Enigmail-Version: 1.5.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-20 12:48, Borislav Petkov wrote:
> On Sun, Jan 20, 2013 at 12:40:11PM +0100, Jörg Rödel wrote:
>> Yes, the BIOS vendor can fix this issue. They need to disable NB clock
>> gating for the IOMMU.
> 
> Right, Udo, you can try Gigabyte first.

I just did so and referred to the kernel.org bugzilla.

> Btw, can't we add a quirk to disable NB clock gating? Maybe Boris and
> Jacob could help. CCed.

That would be most helpful!
Of course I can help testing but the issue happened only 1 time so far.

The person from
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1073384 had more
bad luck in experiencing the issue.

Thanks,
Udo

