Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbbAJTzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:55:33 -0500
Received: from mout.gmx.net ([212.227.17.20]:53521 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbbAJTzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:55:32 -0500
From: Sven Joachim <svenjoac@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: Re: Getting new udev to run with 2.6.28
References: <20150110173920.GA31847@amd> <20150110180532.GA8566@kroah.com>
	<20150110180942.GA10142@amd>
Date: Sat, 10 Jan 2015 20:54:54 +0100
In-Reply-To: <20150110180942.GA10142@amd> (Pavel Machek's message of "Sat, 10
	Jan 2015 19:09:42 +0100")
Message-ID: <87a91q2yy9.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.51 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K0:DRc9LEYUIovuws/bPHZ+7mZP69ZxE3HQarISLhzERK1PN9V/8eP
 zJoc9SZpCinGizKVXePK8lrOqgMEVNXzt6QxHO+c844fHLy97Jw71uo1Jvob1nnUBzxw3E/
 95ncsjzPfFZfJbLpDRebCyevs7EQdOe4cd5TRGOKZGfoeY75qIKN/PWjSmQuUr5d2vATWUZ
 iKL36YdyQYEY7gt+Me0zg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-10 19:09 +0100, Pavel Machek wrote:

> I was hoping someone has devtmpfs patches I could just apply over
> 2.6.28 and get a working system?

IIRC the udev version in Debian 7 does not require devtmpfs (that became
mandatory only in udev 176), but kernel 2.6.32 or higher is required for
other reasons.  See commit 67a77c8bf299f6264f001677becd056316ebce2f in
udev[1].

Cheers,
       Sven


1. https://git.kernel.org/cgit/linux/hotplug/udev.git/commit/?id=67a77c8bf299f6264f001677becd056316ebce2f
