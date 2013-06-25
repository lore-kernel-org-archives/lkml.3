Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3FYNRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:17:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:25467 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab3FYNRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:17:36 -0400
Message-ID: <51C99823.1060503@imgtec.com>
Date: Tue, 25 Jun 2013 14:16:19 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/4] Fix more issues with generic pinconf bindings
References: <201306251455.01540.heiko@sntech.de>
In-Reply-To: <201306251455.01540.heiko@sntech.de>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_25_14_17_35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/13 13:55, Heiko Stübner wrote:
> As Stephen Warren pointed out, some pinconf bindings had deficits
> either in documentation or in the whole thought process.
> 
> Therefore this series tries to fix these issues by improving
> documentation and removing the real controversial bindings for now.
> 
> Of the changed pinconf bindings only the slew-rate had an acutal
> current user (since yesterday). James I hope it's ok to simply
> remove the slew-rate handling from the tz1090 driver until we can
> handle it correctly in dt.

Other than my comment about patch 3 (which since it's the only case I
don't mind too much, it can easily be added back again in the future):

Reviewed-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

