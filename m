Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbaGSCZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 22:25:10 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:65219 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbaGSCZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 22:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <1405717414.30262.12.camel@dabdike.int.hansenpartnership.com>
References: <1405715823-17492-1-git-send-email-xerofoify@gmail.com>
	<1405717414.30262.12.camel@dabdike.int.hansenpartnership.com>
Date: Fri, 18 Jul 2014 22:25:07 -0400
Message-ID: <CAPDOMVjScF=7ES7NU=R6sGOmp7QycKX+uMXL-w+1rNEak4G7Dg@mail.gmail.com>
Subject: Re: [PATCH] parisc: Remove FIXME comment
From: Nick Krause <xerofoify@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: deller@gmx.de, tiwai@suse.de, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, dave.anglin@bell.net,
        linux-parisc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 5:03 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2014-07-18 at 16:37 -0400, Nicholas Krause wrote:
>> The comment for size of frame not being needed is incorrect , the
>> function called needs this parameter.
>
> Actually, that's not correct.  The point of the FIXME is that fram_size
> is only used in a debug print and could be eliminated since the
> internals of the function excluding the debugging statements don't use
> it.
>
> James
>
>

So I need to need a patch removing the parameter from the  function
and this part of the code?
Cheers Nick
