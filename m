Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaHLVI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:08:56 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:35898 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754169AbaHLVIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:08:55 -0400
Message-ID: <53EA8260.4020306@itdev.co.uk>
Date: Tue, 12 Aug 2014 22:08:48 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: atmel_mxt_ts - fix a few issues reported by Coverity
References: <20140811180307.GA25677@core.coreip.homeip.net> <53EA431F.6020908@itdev.co.uk> <53EA43A4.2070301@wwwdotorg.org>
In-Reply-To: <53EA43A4.2070301@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 17:41, Stephen Warren wrote:
>> I've reviewed these changes and they look correct to me. Apologies that
>> they slipped through, most of it is bad merging on my part I think.
>>
>> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> 
> Don't you mean Acked-by or Reviewed-by?

You are right, Acked-by is probably more appropriate in this case.
