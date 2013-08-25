Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab3HYFfZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 01:35:25 -0400
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:39338 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755980Ab3HYFfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 01:35:24 -0400
Message-ID: <52199796.4080800@overkiz.com>
Date: Sun, 25 Aug 2013 07:35:18 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH v4 2/5] mmc: atmel-mci: prepare clk before calling enable
References: <1374132753-15206-1-git-send-email-b.brezillon@overkiz.com> <1374133132-17556-1-git-send-email-b.brezillon@overkiz.com> <87li3qsbk9.fsf@octavius.laptop.org>
In-Reply-To: <87li3qsbk9.fsf@octavius.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 10950221020186048566
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On 25/08/2013 05:18, Chris Ball wrote:
> Hi,
>
> On Thu, Jul 18 2013, Boris BREZILLON wrote:
>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>> avoid common clk framework warnings.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> Okay, pushed to mmc-next for 3.12.

Thanks.

>
> Boris, you got feedback from Thomas Petazzoni and Russell King, but
> you didn't CC either of them on the patch v4

I didn't knew I had to add the reviewers of a patch in the cc list
of the future versions. I'll do it next time.

> , and you didn't write a
> changelog explaining the differences between patches v3 and v4 --
> please do both of those next time.

The changelog is in the cover letter ("Changes since v3").
But I didn't send you this cover letter.

> Also, it looks like the Ack from Ludovic happened away from the MMC
> list, since I don't see a message from Ludovic on the thread here.
> It would be better if the Ack happened somewhere I can see it.

The 'Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>' was added
in the 2nd version of this patch series.
But I don't know if I should have kept it in this version since this 
patch has evolved.


Thanks for these feebacks, I'm still learning the good practices of the 
kernel
submission process.
I'll check these points next time.

Best Regards,

Boris
> Thanks,
>
> - Chris.

