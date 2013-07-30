Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3G3U4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:56:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29596 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3G3U4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:56:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,781,1367996400"; 
   d="scan'208";a="65629833"
X-IronPort-AV: E=Sophos;i="4.89,780,1367996400"; 
   d="scan'208";a="487786699"
Date: Tue, 30 Jul 2013 13:56:01 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Hector Palacios <hector.palacios@digi.com>
CC: Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "surajs@qca.qualcomm.com" <surajs@qca.qualcomm.com>
Subject: Re: [PATCH] bluetooth: remove wrong dependency for BT_ATH3K
Message-ID: <20130730205601.GI17130@pogo>
References: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
 <5438CD3C-E28C-485C-94B8-F743E8B13D4A@holtmann.org>
 <51F7722E.9050708@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51F7722E.9050708@digi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:58:38AM +0200, Hector Palacios wrote:
> This brings an interesting question: shouldn't the firmware download
> part be isolated from the USB driver? After all, I want to
> communicate with a UART bluetooth chip.

There are a few BT firmware upload modules (last I checked at least 2),
I believe it should be possible to stuff all that code a shared
module or even as FreeBSD does it -- treat fw uploading in userspace,
however just keep in mind for quirks [0]. So patches welcomed.

[0] http://wireless.kernel.org/en/users/Drivers/ath3k#AR3011_over_USB

  Luis
