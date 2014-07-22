Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaGVIKB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:10:01 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63876 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVIJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:09:58 -0400
Message-ID: <1406016591.23999.40.camel@marge.simpson.net>
Subject: Re: drbd_worker.c: Remove lines
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 22 Jul 2014 10:09:51 +0200
In-Reply-To: <CAPDOMVikKnHvK-O+20dL1apM=Hi6bDqxn8uVcrhHtsE1sufRUw@mail.gmail.com>
References: <CAPDOMVikKnHvK-O+20dL1apM=Hi6bDqxn8uVcrhHtsE1sufRUw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 02:17 -0400, Nick Krause wrote: 
> There seems to be two fix mes in function in wait_for_work. I was
> wondering can we remove these spinlocks?

Rather than ask someone else this question, take a look to see what the
lock protects and from whom.  If protected thingy cannot possibly be
diddled concurrently, you'll know what to do, if it can be, you'll know
what to do.  If you can't figure it out, move on to the next windmill
until the last one on the planet has been tilted or bounced off of :)

-Mike

