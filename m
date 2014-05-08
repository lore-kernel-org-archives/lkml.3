Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaEHJ2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:28:51 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46543 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaEHJ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:28:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140508090508.GA16423@jak-x230>
References: <536A5A1E.6070004@codeaurora.org>
	<20140508084412.GA20398@mwanda>
	<20140508090508.GA16423@jak-x230>
Date: Thu, 8 May 2014 17:28:46 +0800
Message-ID: <CAJd=RBBNbJnTsu=73o9Yy4dgVw2zUJR9Cc5=eZB+U+WqJ=4KDg@mail.gmail.com>
Subject: Re: [patch v2] Documentation/email-clients.txt: add a section about git
From: Hillf Danton <dhillf@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 5:05 PM, Julian Andres Klode <jak@jak-linux.org> wrote:
> On Thu, May 08, 2014 at 11:44:12AM +0300, Dan Carpenter wrote:
>> +as raw text including all the headers.  Run `cat raw_email.txt | git am`
>
> `cat raw_email.txt | git am` seems a bit pointless. Why not simply
> `git am raw_email.txt`? `git am < raw_email.txt` does the same too
> and avoids the useless cat as well.
>
> No point in running two processes when the same can be done in a
> simpler way in one process, IMO.
>
And this helps most developers little, but is more valuable for those who
dont use 'git send-mail' everyday if the detail of cmdline is provided, say
send a patch file with 'git send-mail' through gmail.

We will say double thanks to you, Dan, if you really help us tame gmail.

And a howto to tame gmail is doule apprecaited.

thanks
Hillf
