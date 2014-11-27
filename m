Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaK0UnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 15:43:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23529 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaK0UnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 15:43:09 -0500
Date: Thu, 27 Nov 2014 23:42:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
Message-ID: <20141127204257.GA11014@mwanda>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
 <CA+55aFzyDC=o_Beg+8hjW8+TQXYWCgQo_yfjgHsTz0LRTiomWA@mail.gmail.com>
 <547620E6.10306@oracle.com>
 <CA+55aFyiCg23eL=y0nE8a-6_tBAtB097J8v_BtpUcHU8sc3hyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyiCg23eL=y0nE8a-6_tBAtB097J8v_BtpUcHU8sc3hyQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:58:43AM -0800, Linus Torvalds wrote:
> I don't think coccinelle can do signedness checks, though, especially
> of the kind that are hidden deep behind some typedef like "loff_t".
> Maybe I'm wrong. Maybe smatch can? Adding Dan Carpenter to the cc..
> 

Smatch knows about datatypes and signedness.

I've written a bunch of integer overflow checks and found some bugs but
the tests have always had too many false positives to publish.  I'll
take a closer look at this next week.

regards,
dan carpenter

