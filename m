Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbaCZQWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 12:22:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43477 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaCZQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 12:22:31 -0400
Date: Wed, 26 Mar 2014 12:22:26 -0400 (EDT)
Message-Id: <20140326.122226.1847173879330664246.davem@davemloft.net>
To: ast@plumgrid.com
Cc: hpa@linux.intel.com, dborkman@redhat.com, netdev@vger.kernel.org,
        hagen@jauu.net, keescook@chromium.org, pmoore@redhat.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 8/9] net: filter: rework/optimize internal
 BPF interpreter's instruction set
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuyQs4Jk+zi9_DxFRnoTFGQ8WXn4aPPJ+yp5XxWb6pkmbQ@mail.gmail.com>
References: <53321E3B.8080709@linux.intel.com>
	<20140325.204628.1622839093852736075.davem@davemloft.net>
	<CAMEtUuyQs4Jk+zi9_DxFRnoTFGQ8WXn4aPPJ+yp5XxWb6pkmbQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Mar 2014 09:22:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 25 Mar 2014 18:58:14 -0700

> So I think we can debate backward jumps later when they actually
> will be up for review.

Then don't mention it in the commit message.
