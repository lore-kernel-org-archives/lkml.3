Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaI1MOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 08:14:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:35648 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbaI1MOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 08:14:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,614,1406617200"; 
   d="scan'208";a="597924650"
Message-ID: <1411906442.11836.24.camel@karhu>
Subject: Re: [PATCH] mtd: ubi: Extend UBI layer debug/messaging capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 28 Sep 2014 15:14:02 +0300
In-Reply-To: <5427C046.5030608@nod.at>
References: <1411886185-7838-1-git-send-email-tlinder@codeaurora.org>
	 <5427C046.5030608@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-28 at 10:01 +0200, Richard Weinberger wrote:
> Tanya,
> 
> Am 28.09.2014 08:36, schrieb Tanya Brokhman:
> > If there is more then one UBI device mounted, there is no way to
> > distinguish between messages from different UBI devices.
> > Add device number to all ubi layer message types.
> > 
> > 
> > Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> 
> Artem's mail is dedekind1@ not dedeking1@. :)

Yeah, it is not after a King named "Dede" :-) I just liked the Richard
Dedekind's theorem back in the University days :-)

> Anyway, instead of passing ubi->ubi_num down to every log function you can
> just pass the ubi object itself and let the log function access ->ubi_num.

Yes, then we potentially may add more than just the device number to the
messages, if we ever need.

-- 
Best Regards,
Artem Bityutskiy

