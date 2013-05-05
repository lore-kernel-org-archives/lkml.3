Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab3EEAEH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 20:04:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60271 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab3EEAEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 20:04:06 -0400
X-Sasl-enc: a4NY4k4nMGCBf3eF5gAxcwIOJkH4yDA8euzn3PgK+X5w 1367712244
Subject: Re: [systemd-devel] [PATCH 2/2] coredump: Handle programs with
 spaces in COMM
From: Colin Walters <walters@verbum.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130503150824.GB24114@tango.0pointer.de>
References: <1367341939.6959.1.camel@localhost>
	 <20130430174731.GC3394@in.waw.pl> <1367349331.6959.80.camel@localhost>
	 <20130501164246.GA7647@redhat.com>
	 <20130503150824.GB24114@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 04 May 2013 20:04:03 -0400
Message-ID: <1367712243.6959.213.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-03 at 17:08 +0200, Lennart Poettering wrote:

> It sounds really wrong to first merge this into one string and then
> split it up again. It sounds much more sensible to instead just pass the
> string array around all the time. What's the reason to make this one
> string first?

I'm wondering if there are compatibility concerns; abrt wouldn't care
from what I can tell if we just changed the kernel.  systemd-coredump is
just plain broken right now.  I'll look for the source to the Ubuntu
one...


