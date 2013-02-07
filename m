Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab3BGOf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:35:56 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:56491 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629Ab3BGOfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:35:53 -0500
Message-ID: <5113BBBF.6000909@synopsys.com>
Date: Thu, 7 Feb 2013 18:35:43 +0400
From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Simek <monstr@monstr.eu>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        <dahinds@users.sourceforge.net>, <gsmecher@threespeedlogic.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <1781360.cmQWHCW5SC@wuerfel> <CAHTX3dJpuTRa4Ff29k95quPMVDO2mBiayPoocnw5R15=5ovOHQ@mail.gmail.com> <201302041724.47331.arnd@arndb.de> <1360031367.14701.47.camel@pasglop> <CAHTX3dL4dScmzgGyqbvPH-7UQvFrjQhHu2zh0iZyzWB=spZS+Q@mail.gmail.com> <1360066756.4529.6.camel@pasglop> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com> <51111133.7000105@synopsys.com> <1360098004.4529.13.camel@pasglop> <511178AC.7080304@synopsys.com> <1360105635.2707.7.camel@pasglop> <CACxGe6u=zhGXm0AO_h354g8OOkAQgdczdw_gCCRxL+=r8hM+-g@mail.gmail.com> <1360186550.2650.4.camel@pasglop> <51139974.2040601@synopsys.com> <CAHTX3dL27B_zt+m9YL665+Un47aSZq59UspW0To=jydBixe_SQ@mail.gmail.com>
In-Reply-To: <CAHTX3dL27B_zt+m9YL665+Un47aSZq59UspW0To=jydBixe_SQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.121.8.160]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 06:31 PM, Michal Simek wrote:
> The origin patch (after some microblaze ioread/iowrite fixes) works ok,
> These additional changes is breaking sysace on microblaze big endian
> ml505 16bit mode.
> 8bit mode just works
>
> Also I have looked at our tree and I see that the mainline kernel misses
> one patch which was sent by Graeme Smecher and it was also Acked-by Grant.
> It is called "Fix device name assignment for SystemACE (from "xs`" to "xsa")."
> Let me resend it too.
>
> Alexey: Can you please confirm that on your arc platform you see broken CF
> partitions name?
>
> Thanks,
> Michal
>

Indeed I had it and fixed myself)
I didn't know about this fix so I've just sent another fix for it - 
https://patchwork.kernel.org/patch/2110811/

Anyways good to know now it is fixed.

Thanks,
Alexey
