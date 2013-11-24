Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3KXAaR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:30:17 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41072 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab3KXAaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:30:14 -0500
Date: Sun, 24 Nov 2013 00:29:45 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Pavel Machek <pavel@ucw.cz>, Maximiliano Curia <maxy@gnuservers.com.ar>,
        Margarita Manterola <margamanterola@gmail.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, bug-readline@gnu.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Large pastes into readline enabled programs causes breakage
 from v2.6.31 onwards
Message-ID: <20131124002945.19bde9ab@alan.etchedpixels.co.uk>
In-Reply-To: <528F54A2.5000802@hurleysoftware.com>
References: <CAP+fKSpvJqeh8JCHisByDBsGWPOWOcDN4qeVYJOn1tgg8HR0eg@mail.gmail.com>
	<CAP+fKSp5ze3-qWHY_D_e3AXxnFM-AB9FBfRLjy0yOFnOp6bp4w@mail.gmail.com>
	<201309030717.57866.a.miskiewicz@gmail.com>
	<201310241800.18490.a.miskiewicz@gmail.com>
	<20131029135036.GA30992@gnuservers.com.ar>
	<5270EBA9.6070302@hurleysoftware.com>
	<20131117182906.GE30012@xo-6d-61-c0.localdomain>
	<528D946B.8030000@hurleysoftware.com>
	<528F54A2.5000802@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 7) Rescan line discipline buffer when changing from non-canonical to canonical
> mode. The real problem with this approach (besides the inefficiency) is that this
> solution could break some (admittedly unknown) program that contrived to exchange
> data in non-canonical mode but read in canonical mode (just not exceeding the
> line discipline buffer limit).

See bugzilla 55981, 55991 btw

Alan
