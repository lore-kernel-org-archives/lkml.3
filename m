Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaIQRNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:13:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64318 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaIQRNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:13:13 -0400
Date: Wed, 17 Sep 2014 10:13:08 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v3 0/7] mtd: denali: A collection of trivial coding style
 fixes
Message-ID: <20140917171308.GC1193@ld-irv-0074>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:04:18PM +0900, Masahiro Yamada wrote:
> 
> 
> Masahiro Yamada (7):
>   mtd: denali: fix the format of comment blocks
>   mtd: denali: remove unnecessary variable initializations
>   mtd: denali: remove unnecessary casts
>   mtd: denali: change the type of iterators to int
>   mtd: denali: remove a set-but-unused variable
>   mtd: denali: remove unnecessary parentheses
>   mtd: denali: fix indents and other trivial things

This series still doesn't apply to l2-mtd.git.

Brian
