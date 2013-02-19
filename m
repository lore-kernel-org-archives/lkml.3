Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934747Ab3BSWRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:17:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:36180 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933538Ab3BSWR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:17:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,697,1355126400"; 
   d="scan'208";a="264763819"
Message-ID: <5123F9F4.70409@intel.com>
Date: Tue, 19 Feb 2013 23:17:24 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.linux@gmail.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>
Subject: Re: [PATCH] dw_dmac: adjust slave_id accordingly to request line
 base
References: <1359371060-9044-1-git-send-email-andriy.shevchenko@linux.intel.com> <1361264544.28241.52.camel@smile>
In-Reply-To: <1361264544.28241.52.camel@smile>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JMHUvf000382

On 2/19/2013 10:02 AM, Andy Shevchenko wrote:
> On Mon, 2013-01-28 at 13:04 +0200, Andy Shevchenko wrote:
>> On some hardware configurations we have got the request line with the offset.
>> The patch introduces convert_slave_id() helper for that cases. The request line
>> base is got from the platform device resources provided by the IORESOURCE_DMA
>> type.
> Hi, Vinod.
>
> v3.8 is just out, and we have not got any proposal from anyone how to
> make our approach better. So, I'm just wondering about current state.
>
> Rafael, could you share your opinion about our case with CSRT and
> request line base (perhaps you need to go through the entire thread)?
>

Well, I can do that, but Mika is the author of the patches, so he should 
know. :-)

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
