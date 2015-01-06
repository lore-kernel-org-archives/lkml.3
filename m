Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbbAFTSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:18:09 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53131 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbbAFTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:18:07 -0500
Date: Tue, 06 Jan 2015 14:18:05 -0500 (EST)
Message-Id: <20150106.141805.2295183028829066436.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: imrep.amz@gmail.com, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, wei.liu2@citrix.com,
        linux-kernel@vger.kernel.org, imrep@amazon.de, aliguori@amazon.com
Subject: Re: [PATCH] xen-netback: fixing the propagation of the transmit
 shaper timeout
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420559647.28863.174.camel@citrix.com>
References: <1420559084-28370-1-git-send-email-imrep.amz@gmail.com>
	<1420559647.28863.174.camel@citrix.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Jan 2015 11:18:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Tue, 6 Jan 2015 15:54:07 +0000

> On Tue, 2015-01-06 at 16:44 +0100, Imre Palik wrote:
>> From: "Palik, Imre" <imrep@amazon.de>
>> 
>> Since e9ce7cb6b107 ("xen-netback: Factor queue-specific data into queue struct"),
>> the transimt shaper timeout is always set to 0.  The value the user sets via
>> xenbus is never propagated to the transmit shaper.
>> 
>> This patch fixes the issue.
>> 
>> Cc: Anthony Liguori <aliguori@amazon.com>
>> Signed-off-by: Imre Palik <imrep@amazon.de>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Applied and queued up for -stable, thanks.
