Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3FZShO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:37:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45914 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3FZShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:37:11 -0400
Date: Wed, 26 Jun 2013 11:37:08 -0700 (PDT)
Message-Id: <20130626.113708.974853729895213353.davem@davemloft.net>
To: stefan.bader@canonical.com
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, hayeswang@realtek.com, romieu@fr.zoreil.com
Subject: Re: [16/26] r8169: fix 8168evl frame padding.
From: David Miller <davem@davemloft.net>
In-Reply-To: <51CAAB98.6040706@canonical.com>
References: <lsq.1372214158.437609827@decadent.org.uk>
	<51CAAB98.6040706@canonical.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 26 Jun 2013 10:51:36 +0200

>> [ Upstream commits e5195c1f31f399289347e043d6abf3ffa80f0005 and
>>   b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 ]
 ...
> No abjection, just make sure that
> 
> commit b423e9ae49d78ea3f53b131c8d5a6087aed16fd6
 ...
> is included as well.

Read the commit message carefully, the two commits were folded into
one exactly to deal with this issue.
