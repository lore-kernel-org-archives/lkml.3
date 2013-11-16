Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab3KPL2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:28:42 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53548 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3KPL21 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:28:27 -0500
MIME-Version: 1.0
Date: Sat, 16 Nov 2013 12:28:25 +0100
Message-ID: <CADDKRnBf6OK3bOS0SBKMTgwxe-NpE2K9K6Z5sdEDjhr4Z43eBQ@mail.gmail.com>
Subject: [V13-prerc]: REGRESSION: "*ERROR* Timed out waiting for forcewake old
 ack to clear"
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On startup I get the following error display on the console:
"*ERROR* Timed out waiting for forcewake old ack to clear"

I already reported this error a year ago at the time of v3.7
( see https://lkml.org/lkml/2012/11/27/355)
which was fixed later on.

Now this error is back again.  Kernel 3.12.0-09888-gf63c48


Jörg
