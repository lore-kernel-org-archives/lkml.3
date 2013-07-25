Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3GYB2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:28:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:44951 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab3GYB2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:28:11 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [RFC PATCH - diffstat only] include/net: Remove extern from
 function prototypes
Date: Thu, 25 Jul 2013 01:27:49 +0000 (UTC)
Message-ID: <kspuuk$k2v$1@ger.gmane.org>
References: <1374602291.3387.17.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 119.6.80.230
User-Agent: slrn/0.9.9p1 (Linux)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013 at 17:58 GMT, Joe Perches <joe@perches.com> wrote:
> Function prototypes don't need to be declared
> extern in .h files.  It's assumed by the compiler
> and is as unnecessary as using auto is when
> declaring automatic/local variables in a block.
>

Since we all know this, why bother it? Having "extern" doesn't harm
readability, instead it probably helps.

...
>
> I believe it makes grepping for extern useful as
> all the matches are actual variables and structs.
>

You need a semantic tool.

