Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab3LIUxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:53:05 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40805 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3LIUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:53:03 -0500
MIME-Version: 1.0
In-Reply-To: <CACwUX0PEYGsNMDvy85EsrApWzNU3iTyY-1KHMaj1ay0xxKX6RQ@mail.gmail.com>
References: <CACwUX0PEYGsNMDvy85EsrApWzNU3iTyY-1KHMaj1ay0xxKX6RQ@mail.gmail.com>
Date: Mon, 9 Dec 2013 13:53:00 -0700
Message-ID: <CACwUX0PGGM99-2H41S0eqOVLsh-7+Dan+gcy9deK1movx_wWPQ@mail.gmail.com>
Subject: Fwd: UBIFS recovery taking too long
From: David Mosberger-Tang <dmosberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've had no luck getting any response from the linux-mtd mailing list
regarding the issue reported below.
I think it is a very serious issue since it can easily render an
embedded system unusable.

  --david

---------- Forwarded message ----------
From: David Mosberger-Tang <dmosberger@gmail.com>
Date: Thu, Nov 7, 2013 at 11:44 AM
Subject: UBIFS recovery taking too long
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>


We recently encountered a strange issue where UBIFS recovery is
suddenly taking a lot longer than usual (v3.7-based kernel).  In our
case, recovery took about 30 seconds.  This caused a serious problem
because our watchdog timer was set to 15 seconds, effectively
rendering the devices unbootable.

Does anybody know what triggers this slow recovery mode?  Also, how
can we calculate a worst-case recovery time for a given flash
chip-size.

Thanks,

  --david
