Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaIWVGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:06:21 -0400
Received: from blu004-omc2s32.hotmail.com ([65.55.111.107]:58117 "EHLO
	BLU004-OMC2S32.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756328AbaIWVGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:06:19 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 17:06:19 EDT
X-TMN: [hK1TjQLOiWeOoNBfEvoNC4P2+j776Jnl]
X-Originating-Email: [dave.anglin@bell.net]
Message-ID: <BLU436-SMTP6279A45A0CDDB3AC2C3BDF97B00@phx.gbl>
Date: Tue, 23 Sep 2014 16:59:20 -0400
From: John David Anglin <dave.anglin@bell.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Helge Deller <deller@gmx.de>, nick <yocto6@gmail.com>,
        jejb@parisc-linux.org
CC: akpm@linux-foundation.org, himangi774@gmail.com, julia.lawall@lip6.fr,
        mgorman@suse.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FIX MES in init.c
References: <54207769.2020105@gmail.com> <5421DC9F.2080504@gmx.de>
In-Reply-To: <5421DC9F.2080504@gmx.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2014 20:59:10.0215 (UTC) FILETIME=[38DA7170:01CFD771]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/23/2014 4:48 PM, Helge Deller wrote:
> The FIXME: is misleading. It should maybe better read "HINT:" or 
> something like that.
> Trivially it's basically just casting the symbol so that the compiler
> will produce the correct code later on.
> There is nothing you could try to "fix".
Why not just remove "FIXME: " from these comments?

Dave

-- 
John David Anglin    dave.anglin@bell.net

