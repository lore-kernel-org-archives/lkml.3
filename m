Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3BDPDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:03:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:32961 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3BDPDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:03:43 -0500
Message-ID: <510FCDD9.7060900@windriver.com>
Date: Mon, 4 Feb 2013 10:03:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <artem.bityutskiy@linux.intel.com>
CC: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: fix random pointer dereference in OF device name
 handling
References: <1358967548-25491-1-git-send-email-paul.gortmaker@windriver.com> <1359965101.13791.11.camel@sauron.fi.intel.com>
In-Reply-To: <1359965101.13791.11.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-04 03:05 AM, Artem Bityutskiy wrote:
> On Wed, 2013-01-23 at 13:59 -0500, Paul Gortmaker wrote:
>> Here is the output from an mpc8548 based board.  There are
>> three instances of missing device name here:
> 
> A similar fix is already in the linux-mtd.git tree.

OK, I see it in linux-next for 3.9 (commit 7dfe4be351e816) but
it needs to get to mainline/Linus before 3.8 gets released,
since that is where the regression is introduced (and that
is why I ended up not seeing the fix, and redoing it, as
I was working off of mainline).

$ git describe --contains d68cbdd4fb
v3.8-rc1~47^2~53

Thanks,
Paul.


> 
