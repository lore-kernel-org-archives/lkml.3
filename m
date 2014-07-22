Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbaGVRn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:43:57 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62540 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaGVRn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <1406016591.23999.40.camel@marge.simpson.net>
References: <CAPDOMVikKnHvK-O+20dL1apM=Hi6bDqxn8uVcrhHtsE1sufRUw@mail.gmail.com>
	<1406016591.23999.40.camel@marge.simpson.net>
Date: Tue, 22 Jul 2014 13:43:55 -0400
Message-ID: <CAPDOMViu2y1g2b6MXPSqh6_hbFjzo4BRmc39kLBjeF9ecwWN+A@mail.gmail.com>
Subject: Re: drbd_worker.c: Remove lines
From: Nick Krause <xerofoify@gmail.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 4:09 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> On Tue, 2014-07-22 at 02:17 -0400, Nick Krause wrote:
>> There seems to be two fix mes in function in wait_for_work. I was
>> wondering can we remove these spinlocks?
>
> Rather than ask someone else this question, take a look to see what the
> lock protects and from whom.  If protected thingy cannot possibly be
> diddled concurrently, you'll know what to do, if it can be, you'll know
> what to do.  If you can't figure it out, move on to the next windmill
> until the last one on the planet has been tilted or bounced off of :)
>
> -Mike
>
Mike ,
Thanks for the advice.
Cheers Nick
