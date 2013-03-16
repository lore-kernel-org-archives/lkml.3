Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3CPEiw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 00:38:52 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:58843 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3CPEiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 00:38:51 -0400
Message-ID: <5143F6B2.4070308@synopsys.com>
Date: Sat, 16 Mar 2013 10:06:02 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: remove #ifdef-ed out include of dead header
References: <1363364177.1335.123.camel@x61.thuisdomein>
In-Reply-To: <1363364177.1335.123.camel@x61.thuisdomein>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013 09:46 PM, Paul Bolle wrote:
> There's no (Kconfig) macro CONFIG_BLOCK_DEV_RAM. (CONFIG_BLK_DEV_RAM
> does exist though.) But linux/blk.h got killed in 2005 anyway (in a
> patch titled "kill blk.h"), so these three lines can be removed.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied to next.

P.S. The msg to linux-snps-arc would have bounced back since the list couldn't be
created - I have a patch to be sent to Linus to remove that.

Thx,
-Vineet
