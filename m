Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3IZC6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:58:15 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35487 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZC6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:58:14 -0400
Message-ID: <5243A29C.6080009@ahsoftware.de>
Date: Thu, 26 Sep 2013 04:57:32 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch guide for newbies
References: <20130923090100.GE6192@mwanda> <CAErSpo5XgvuG=75nExa7yCa7C+Bxhk+1LwruxY8pv2DU+r-_aA@mail.gmail.com> <5241CB44.8080004@ahsoftware.de> <CA+MoWDpnNjeEN+Crzh2kQ7DPJ_DqEOP4z-9n3=EqP7hiPgZRXg@mail.gmail.com> <CAErSpo4X0-PEYtZrY2r4GKmzTJhHK3eKdXrbccJhB7wVkVCYLA@mail.gmail.com> <52420DF1.7060108@ahsoftware.de> <20130926021130.GD13318@ZenIV.linux.org.uk> <5243A165.2060204@ahsoftware.de>
In-Reply-To: <5243A165.2060204@ahsoftware.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 04:52, schrieb Alexander Holler:

> I'm aware of people which do nest 8 levels deep just to avoid a return,
> break or goto.
> 
> But trying to limit that by limiting the line length is like ...
> (choose your own own misguided comparison, it's too late for me I
> currently only meorize some of those which don't make sense in english)

But I'm still able to offer a solution: ;)

limit the number of tabs, not the line length (at least not to 80).

Regards,

Alexander Holler
