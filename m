Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664AbaCUOhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:37:33 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55508 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaCUOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:37:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140321122434.06755C40567@trevor.secretlab.ca>
References: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
 <20140317182953.GA10565@kroah.com> <20140319153008.GC31293@kroah.com> <20140321122434.06755C40567@trevor.secretlab.ca>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 21 Mar 2014 14:37:10 +0000
X-Google-Sender-Auth: r9GC5vBIEH1pk26Mfd5XjZSym74
Message-ID: <CACxGe6uUauuF=JUVvoc-se+neJVbCU9TbxORPvbahp66qJY4Jg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the v4l-dvb tree
To: Greg KH <greg@kroah.com>, Russell King <rmk@arm.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 12:24 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 19 Mar 2014 08:30:08 -0700, Greg KH <greg@kroah.com> wrote:
>> On Mon, Mar 17, 2014 at 10:27:36PM +0000, Russell King wrote:
>> > However, I still find myself coming back to a fundamental question: why
>> > were these bindings fine in April 2013, passed review, and were acked,
>> > but not fine today.  Here's the links to the emails acking their
>> > introduction which Sylwester Nawrocki sent me:
>> >
>> >   http://www.spinics.net/lists/linux-media/msg61899.html
>> >   http://www.spinics.net/lists/linux-media/msg62458.html
>> >
>> > So... *shrug*.  Make of this what you will.
>>
>> Thanks for the details, I'll just leave my tree as-is for now, as that
>> seems the simplest thing to do.
>
> Yes, please leave it in your tree. I've caused noise and trouble than I
> should, and could have handled it differently. I apologize.

s/should/should not have/

g.
