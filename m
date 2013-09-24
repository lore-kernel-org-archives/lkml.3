Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3IXUAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 16:00:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43159 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3IXUAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 16:00:17 -0400
Date: Tue, 24 Sep 2013 22:59:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        Bjorn Helgaas <bhelgaas@google.com>, kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
Message-ID: <20130924195958.GO6247@mwanda>
References: <20130923090100.GE6192@mwanda>
 <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com>
 <5241CB44.8080004@ahsoftware.de>
 <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 09:29:49PM +0200, Peter Senna Tschudin wrote:
> I was about to disagree because I've never seen variables named a, b
> or c, but I found that there are at least 2238 variables named a, b or
> c in linux-next. This is not good.
> 

In XGIfb_mode_rate_to_ddata() we have:

	int B, C, D, F, temp, j;

The A and E variables were removed when the code was refactored.  ;P
Places like this are fairly rare in the kernel outside of the staging/
directory.

There are lots of times where a single letter variable name is very
natural.

	char c;

C is terse.  This is explained in Documentation/CodingStyle.

regards,
dan carpenter

