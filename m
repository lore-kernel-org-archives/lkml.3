Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3JHALQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:11:16 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52800 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab3JHALO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:11:14 -0400
MIME-Version: 1.0
In-Reply-To: <1381190594.2081.228.camel@joe-AO722>
References: <1381189523.2081.225.camel@joe-AO722> <20131007165626.be437f74a4ba39e2be21af55@linux-foundation.org>
 <1381190594.2081.228.camel@joe-AO722>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 7 Oct 2013 18:10:53 -0600
Message-ID: <CAErSpo75uQL5woms175LR4KCAmqT_SWpQcXGdbKccgVPdh6xhg@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Add check for sscanf without return use
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 6:03 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-10-07 at 16:56 -0700, Andrew Morton wrote:
>> On Mon, 07 Oct 2013 16:45:23 -0700 Joe Perches <joe@perches.com> wrote:
>>
>> > Naked use sscanf can be troublesome.
>>
>> It would be helpful to expand on "troublesome"?
>
> Dunno, you either know or the couple of paragraphs
> it takes to explain with examples won't really be
> too helpful in a commit log.

It would be helpful to me, since I don't write code with sscanf every
day.  A URL to an LKML description or something would be enough if the
commit log size is the concern.

Bjorn
