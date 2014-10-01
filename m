Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbaJAFek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:34:40 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49151 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJAFej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:34:39 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/1 net-next] ieee802154: fix __init functions
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1412141266-12258-1-git-send-email-fabf@skynet.be>
Date: Wed, 1 Oct 2014 07:34:39 +0200
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <56FE06A5-5C2A-42E4-B01A-15EB36BAADE5@holtmann.org>
References: <1412141266-12258-1-git-send-email-fabf@skynet.be>
To: Fabian Frederick <fabf@skynet.be>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

> Commit 3243acd37fd9
> ("ieee802154: add __init to lowpan_frags_sysctl_register")
> 
> added __init to lowpan_frags_ns_sysctl_register instead of
> lowpan_frags_sysctl_register
> 
> Suggested-by: Alexander Aring <alex.aring@gmail.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> net/ieee802154/reassembly.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

when trying to apply this to bluetooth-next kernel, I am getting this:

Applying: ieee802154: fix __init functions
error: patch failed: net/ieee802154/reassembly.c:498
error: net/ieee802154/reassembly.c: patch does not apply
Patch failed at 0001 ieee802154: fix __init functions

Regards

Marcel

