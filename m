Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3KUSTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:19:36 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43521 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KUSTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:19:35 -0500
Date: Thu, 21 Nov 2013 13:19:33 -0500 (EST)
Message-Id: <20131121.131933.1763933667490268654.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: joe@perches.com, michael.opdenacker@free-electrons.com,
        inaky.perez-gonzalez@intel.com, linux-wimax@intel.com,
        wimax@linuxwimax.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: remove dead code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385018850.14273.0.camel@jlt4.sipsolutions.net>
References: <1385005391-18379-1-git-send-email-michael.opdenacker@free-electrons.com>
	<1385007469.2164.39.camel@joe-AO722>
	<1385018850.14273.0.camel@jlt4.sipsolutions.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 21 Nov 2013 10:19:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 21 Nov 2013 08:27:30 +0100

> On Wed, 2013-11-20 at 20:17 -0800, Joe Perches wrote:
>> On Thu, 2013-11-21 at 04:43 +0100, Michael Opdenacker wrote:
>> > This removes a code line that is between a "return 0;" and an error label.
>> > This code line can never be reached.
>> 
>> Adding Johannes Berg who added this oversight.
> 
> Obviously, sorry about that. I seem to remember deleting *something*
> there (like another error label) but I guess I missed that line.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Applied, thanks.
