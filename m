Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936180Ab3DHVM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:12:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53067 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935958Ab3DHVM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:12:56 -0400
Date: Mon, 08 Apr 2013 17:12:54 -0400 (EDT)
Message-Id: <20130408.171254.1610343775047047438.davem@davemloft.net>
To: mark.d.rustad@intel.com
Cc: michael.riesch@omicron.at, netdev@vger.kernel.org,
        gregkh@linuxfoundation.org, jbenc@redhat.com, tytso@mit.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtnetlink: Call nlmsg_parse() with correct header
 length
From: David Miller <davem@davemloft.net>
In-Reply-To: <CD31A507-C3E1-4499-9F06-2F83B3FBFE61@intel.com>
References: <e04bc546-fcf6-41d2-a585-5fddff388e06@mary.at.omicron.at>
	<CD31A507-C3E1-4499-9F06-2F83B3FBFE61@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 08 Apr 2013 14:12:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rustad, Mark D" <mark.d.rustad@intel.com>
Date: Mon, 8 Apr 2013 18:13:36 +0000

> On Apr 8, 2013, at 8:45 AM, Michael Riesch <michael.riesch@omicron.at> wrote:
> 
>> 
>> Signed-off-by: Michael Riesch <michael.riesch@omicron.at>
 ...
> I found that fcoemon has also been triggering these messages for
> some time. I found the same problem and arrived at exactly the same
> solution. I would have already sent it, but it is still in
> validation. As far as I am concerned:
> 
> Acked-by: Mark Rustad <mark.d.rustad@intel.com>

Looks good to me too, applied and queued up for -stable, thanks!
