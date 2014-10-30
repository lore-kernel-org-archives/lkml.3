Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbaJ3Tn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:43:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58523 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724AbaJ3Tn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:43:26 -0400
Date: Thu, 30 Oct 2014 15:43:23 -0400 (EDT)
Message-Id: <20141030.154323.1702996635200338108.davem@davemloft.net>
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org, hs@denx.de, mugunthanvnm@ti.com,
        netdev@vger.kernel.org
Subject: Re: Mistake in commit 0d961b3b52f566f823070ce2366511a7f64b928c
 breaks cpsw non dual_emac mode.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141028170242.GA24112@csclub.uwaterloo.ca>
References: <20141028170242.GA24112@csclub.uwaterloo.ca>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 12:43:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 28 Oct 2014 13:02:42 -0400

> I believe commit 0d961b3b52f566f823070ce2366511a7f64b928c made a mistake
> while correcting a bug.

This patch submission is not properly formed.

You subject line should be of the form:

subsystem: Description.

"subsystem" here would be "cpsw: " or something like that.

Secondly, you should not refer to a commit ID in the patch
Subject line, instead just describe exactly what is being
fixed in the most succinct yet complete manner that is
possible.

Thirdly, when you do refer to commit ID's in your commit
message body you must do so in the following format:

${SHA1_ID} ("Commit message header line text.")

The commit message body is also not a place to have a general
discussion.  Please avoid saying things like "I think", for example.
State facts, and be exact about what the problem is and exactly
how you are fixing it.

Because this commit message will be read by others looking at your
change days, weeks, years from now.

Thanks.
