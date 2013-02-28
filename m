Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab3B1JXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:23:22 -0500
Received: from mercuryimc.plus.com ([80.229.200.144]:43487 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779Ab3B1JXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:23:14 -0500
Message-ID: <512F2201.6010407@mimc.co.uk>
Date: Thu, 28 Feb 2013 09:23:13 +0000
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: JFFS2 corruption
References: <512CD9BA.3080300@mimc.co.uk> <20130227101824.6e18ba21fb99070594420f29@canb.auug.org.au> <512E2241.9040705@mimc.co.uk> <518397C60809E147AF5323E0420B992E3EA8EF4A@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA8EF4A@DBDE01.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/13 04:11, Philip, Avinash wrote:
> On Wed, Feb 27, 2013 at 20:42:01, Mark Jackson wrote:
>>
>> Okay, just tested 3v8 plus:-
>>
>> https://patchwork.kernel.org/patch/1931251/
>> https://patchwork.kernel.org/patch/1931221/
>> https://patchwork.kernel.org/patch/1931201/
>> and changed drivers/mtd/nand/elm.c, line 388 "ti,am33xx-elm" to "ti,am3352-elm"
>>
>> This produces an identical corruption.
>>
>> I have also tested next-20130225 and next-20130227, and both cause the same corruption.
> 
> JFFS2 is not supported in am335x with BCH8 ecc scheme because of ECC layout constraints.
> Reasons for disabling JFFS2 support documented in the wiki
> http://processors.wiki.ti.com/index.php/AM335x_JFFS2_Support_Guide#Reasons_for_disabling_JFFS2_support

Aha ... thanks for the link.

I'll move over to UBIFS then, although I did have issues with that too (which is why I went back
to JFFS2), but I'll start another thread if needs be.

Cheers
Mark J.
