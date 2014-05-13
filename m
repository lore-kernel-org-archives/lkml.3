Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaEMQTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:19:46 -0400
Received: from canardo.mork.no ([148.122.252.1]:45578 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaEMQTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:19:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux-pm mailing list <linux-pm@lists.osdl.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.15-rc: regression in suspend
Organization: m
References: <20140513160926.GA3621@amd.pavel.ucw.cz>
Date: Tue, 13 May 2014 18:19:30 +0200
In-Reply-To: <20140513160926.GA3621@amd.pavel.ucw.cz> (Pavel Machek's message
	of "Tue, 13 May 2014 18:09:26 +0200")
Message-ID: <87wqdpy7l9.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> There seems to be regression in 3.15 w.r.t. suspend to ram and suspend
> to disk.
>
> Resume sometiems works, but often, system is half-usable, with "what
> do you want to do suspend/hibernate" dialog staying on screen.
>
> I did echo disk > /sys/power/state, and echo never returned to the
> shell prompt. (X was not really working, either.)
>
> It is still there on 3.15.0-rc3+. I'll update to rc5 now.
>
> Any ideas?

This maybe? https://bugs.freedesktop.org/show_bug.cgi?id=76554


Bjørn
