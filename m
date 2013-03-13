Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106Ab3CMOKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 10:10:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43929 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3CMOKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 10:10:49 -0400
Date: Wed, 13 Mar 2013 10:11:00 -0400 (EDT)
Message-Id: <20130313.101100.2171722464896294416.davem@davemloft.net>
To: vyasevich@gmail.com
Cc: xufeng.zhang@windriver.com, nhorman@tuxdriver.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sctp: don't break the loop while meeting the
 active_path so as to find the matched transport
From: David Miller <davem@davemloft.net>
In-Reply-To: <514084B0.4050906@gmail.com>
References: <1362728377-11025-1-git-send-email-xufeng.zhang@windriver.com>
	<514084B0.4050906@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 13 Mar 2013 07:10:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevich@gmail.com>
Date: Wed, 13 Mar 2013 09:52:48 -0400

> On 03/08/2013 02:39 AM, Xufeng Zhang wrote:
>> sctp_assoc_lookup_tsn() function searchs which transport a certain TSN
>> was sent on, if not found in the active_path transport, then go search
>> all the other transports in the peer's transport_addr_list, however,
>> we
>> should continue to the next entry rather than break the loop when meet
>> the active_path transport.
>>
>> Signed-off-by: Xufeng Zhang <xufeng.zhang@windriver.com>
 ...
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
...
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>

Applied, thanks everyone.
