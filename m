Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab3IZDEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:04:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38802 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IZDEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:04:52 -0400
Date: Thu, 26 Sep 2013 04:04:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
Message-ID: <20130926030448.GG13318@ZenIV.linux.org.uk>
References: <20130923090100.GE6192@mwanda>
 <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com>
 <5241CB44.8080004@ahsoftware.de>
 <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com>
 <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com>
 <52420DF1.7060108@ahsoftware.de>
 <20130926021130.GD13318@ZenIV.linux.org.uk>
 <5243A165.2060204@ahsoftware.de>
 <5243A29C.6080009@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243A29C.6080009@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:57:32AM +0200, Alexander Holler wrote:
> Am 26.09.2013 04:52, schrieb Alexander Holler:
> 
> > I'm aware of people which do nest 8 levels deep just to avoid a return,
> > break or goto.
> > 
> > But trying to limit that by limiting the line length is like ...
> > (choose your own own misguided comparison, it's too late for me I
> > currently only meorize some of those which don't make sense in english)
> 
> But I'm still able to offer a solution: ;)
> 
> limit the number of tabs, not the line length (at least not to 80).

With that limited (and it's visually harder to keep track of), what's
the problem with 80-column limit on line length?  Just how long do
you want those "descriptive names" to be?
