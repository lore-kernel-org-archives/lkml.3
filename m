Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab3KQViX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:38:23 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52495 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3KQViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:38:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131117182906.GE30012@xo-6d-61-c0.localdomain>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
	<CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
	<201309030717.57866.a.miskiewicz@gmail.com>
	<201310241800.18490.a.miskiewicz@gmail.com>
	<20131029135036.GA30992@gnuservers.com.ar>
	<5270EBA9.6070302@hurleysoftware.com>
	<20131117182906.GE30012@xo-6d-61-c0.localdomain>
Date: Sun, 17 Nov 2013 22:38:13 +0100
Message-ID: <CAP+fKSp0rk7Y=zeKwcqNnQj2td521VL_PqW63ZXNwrZURorb2A@mail.gmail.com>
Subject: Re: Large pastes into readline enabled programs causes breakage from
 v2.6.31 onwards
From: Margarita Manterola <margamanterola@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Maximiliano Curia <maxy@gnuservers.com.ar>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Linux kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI,

On Sun, Nov 17, 2013 at 7:29 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Any news?

I'm also not capable of doing the analysis requested, but I want to
add a link for the the fact that Canonical has applied the patch to
the kernels shipped in Ubuntu, and up to now there have been no
reports of problems:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1208740

It was applied in Saucy on Sept. 11th. Ported to the previous Ubuntu
versions on Oct. 24th through the "proposed" mechanism (only reaches a
portion of the users).  Released in the official kernels on Nov. 8th.

Since a few days, then, everyone running an updated Ubuntu system,
regardless of the specific version, should have this patch.

-- 
Besos,
Marga
