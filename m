Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651AbaCZAqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:46:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33115 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaCZAqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:46:30 -0400
Date: Tue, 25 Mar 2014 20:46:28 -0400 (EDT)
Message-Id: <20140325.204628.1622839093852736075.davem@davemloft.net>
To: hpa@linux.intel.com
Cc: dborkman@redhat.com, ast@plumgrid.com, netdev@vger.kernel.org,
        hagen@jauu.net, keescook@chromium.org, pmoore@redhat.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 8/9] net: filter: rework/optimize internal
 BPF interpreter's instruction set
From: David Miller <davem@davemloft.net>
In-Reply-To: <53321E3B.8080709@linux.intel.com>
References: <1395749457-16178-9-git-send-email-dborkman@redhat.com>
	<20140325.201712.1651156258234145348.davem@davemloft.net>
	<53321E3B.8080709@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Mar 2014 17:46:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Tue, 25 Mar 2014 17:24:27 -0700

> If you allow loops, it greatly increases the expressibility of the
> language, but we would really need another control to limit CPU usage.

We don't want super expressibility.

We want an extremely simple, trivial to validate, filtering language.
