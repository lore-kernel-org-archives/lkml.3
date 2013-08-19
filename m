Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849Ab3HSNkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 09:40:47 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:46349 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3HSNkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 09:40:45 -0400
Date: Mon, 19 Aug 2013 09:40:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Terry Suereth <terry.suereth@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the libata tree
Message-ID: <20130819134039.GB6176@htj.dyndns.org>
References: <20130819115401.1f3ce4c2479645d72fb5cb00@canb.auug.org.au>
 <CANQSiW2n1qo0YyR_jEYkNkDaDAukH6EEqNYA0nBxO1Sv7aUTAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANQSiW2n1qo0YyR_jEYkNkDaDAukH6EEqNYA0nBxO1Sv7aUTAg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 08:18:55PM -0700, Terry Suereth wrote:
> Per my original patch, "0x3x26" in code should be "0x3726" (as in the
> unpatched version).  I refer to "x26" in comments as a forward-looking
> assumption, but AFAIK only 3726 and 3826 exist at this time.

Heh... No idea how that happened.  Fixed.  Sorry about the trouble.

-- 
tejun
