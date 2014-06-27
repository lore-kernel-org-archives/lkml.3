Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaF0Xtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:49:53 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47952 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaF0Xtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:49:51 -0400
MIME-Version: 1.0
Date: Fri, 27 Jun 2014 16:49:50 -0700
Message-ID: <CAEn7tidaRxbLwQti8joDgq48K2YCAVE3uG-q6ZR=jEWAgm2tPg@mail.gmail.com>
Subject: Re: [PATCH v2 0/14] input: cyapa: re-architecture driver to support
 multi-trackpads in one driver
From: Patrik Fimml <patrikf@google.com>
To: Dudley Du <dudl@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

I tried to apply your patchset today, but was not successful: it seems
like tabs have been replaced by spaces, and there's a Cypress
signature and a winmail.dat file added to every email, making it
impossible to apply your patches directly.

I've tried to rule out errors on my end. I checked with
http://marc.info/?l=linux-input&m=140203994303131&q=raw that the
original email indeed has all tabs replaced with spaces.

Can you fix your email setup so that these things don't happen - there
is some documentation in Documentation/SubmittingPatches and
Documentation/email-clients.txt - and send the patches again?

Alternatively, maybe you could at least send the patches as
attachments (as output by git format-patch), so that your email system
doesn't mess with them. That's probably not the preferred solution for
the general lkml audience, but would work as a short-term solution for
me.

If I'm mistaken here and someone else was able to apply the patches
successfully, please point me in the right direction.

Thanks,
Patrik
