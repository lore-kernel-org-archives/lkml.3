Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaHLQjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:39:05 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:11672 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685AbaHLQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:39:04 -0400
Message-ID: <53EA431F.6020908@itdev.co.uk>
Date: Tue, 12 Aug 2014 17:38:55 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts - fix a few issues reported by Coverity
References: <20140811180307.GA25677@core.coreip.homeip.net>
In-Reply-To: <20140811180307.GA25677@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/14 19:03, Dmitry Torokhov wrote:
> This should fix the following issues reported by Coverity:
> 
> *** CID 1230625:  Logically dead code  (DEADCODE)
> /drivers/input/touchscreen/atmel_mxt_ts.c: 1692 in mxt_initialize()
> 
> *** CID 1230627:  Missing break in switch  (MISSING_BREAK)
> /drivers/input/touchscreen/atmel_mxt_ts.c: 1436 in mxt_get_object_table()
> 
> *** CID 1230629:  Out-of-bounds write  (OVERRUN)
> /drivers/input/touchscreen/atmel_mxt_ts.c: 1267 in mxt_update_cfg()
> 
> *** CID 1230632:  Unused pointer value  (UNUSED_VALUE)
> /drivers/input/touchscreen/atmel_mxt_ts.c: 1211 in mxt_update_cfg()
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I've reviewed these changes and they look correct to me. Apologies that
they slipped through, most of it is bad merging on my part I think.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
