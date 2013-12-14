Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3LNSRN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 13:17:13 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:46314 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab3LNSRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 13:17:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131214170104.GD29362@pd.tnic>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
	<20131214170104.GD29362@pd.tnic>
Date: Sat, 14 Dec 2013 23:47:10 +0530
Message-ID: <CAMpEsFF2RjRYUvG7MivvWUmEV1kTn493=oNa30ASfQ+n+19akw@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: edac: Mark the function amd64_decode_bus_error()
 as static in amd64_edac.c
From: Rashika Kheria <rashika.kheria@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 10:31 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Sat, Dec 14, 2013 at 07:28:24PM +0530, Rashika Kheria wrote:
>> This patch marks the function amd64_decode_bus_error() as static in
>> amd64_edac.c because it is not used outside this file.
>>
>> Thus, it also eliminates the following warning in amd64_edac.c:
>> drivers/edac/amd64_edac.c:2038:6: warning: no previous prototype for ‘amd64_decode_bus_error’ [-Wmissing-prototypes]
>
> How do you trigger this? .config and output of
>
> gcc --version
>
> please.
>
> I've never seen this warning before.
>
> --
> Regards/Gruss,
>     Boris.
>

Hi Borislav,

My gcc version is 4.6.3. You can trigger these warnings by adding
-Wmissing-prototypes to KBUILD_CFLAGS in the top-level Makefile, and
do a build with defconfig or allyesconfig. It will show all warnings
of missing prototype.

Thanks ,
-- 
Rashika Kheria
B.Tech CSE
IIIT Hyderabad
