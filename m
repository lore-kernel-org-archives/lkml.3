Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3JBX7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 19:59:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51732 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3JBX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 19:59:28 -0400
Date: Wed, 02 Oct 2013 19:59:27 -0400 (EDT)
Message-Id: <20131002.195927.381972750426724578.davem@davemloft.net>
To: rientjes@google.com
Cc: sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix generic hugetlb pte check return type.
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1310021531030.18461@chino.kir.corp.google.com>
References: <20131002.142509.1450460988268165850.davem@davemloft.net>
	<alpine.DEB.2.02.1310021531030.18461@chino.kir.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 02 Oct 2013 16:59:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Wed, 2 Oct 2013 15:34:48 -0700 (PDT)

> On Wed, 2 Oct 2013, David Miller wrote:
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
>> ---
>> 
>> Anyone mind if I push this through the sparc tree?
>> 
> 
> Makes sense since it's the only arch that appears affected.

Ok, thanks for reviewing.
