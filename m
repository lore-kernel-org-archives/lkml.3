Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbbAJTNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 14:13:43 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:41297 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbbAJTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 14:13:42 -0500
Date: Sat, 10 Jan 2015 21:13:35 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        khilman@kernel.org, ivo.g.dimitrov.75@gmail.com,
        Greg KH <greg@kroah.com>
Subject: Re: Getting new udev to run with 2.6.28
Message-ID: <20150110191335.GA5125@fuloong-minipc.musicnaut.iki.fi>
References: <20150110173920.GA31847@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150110173920.GA31847@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jan 10, 2015 at 06:39:20PM +0100, Pavel Machek wrote:
> N900 has real problems on 3.19, and 2.6.28 should be very well
> debugged version. Getting it to compile on recent distribution was
> fun, but I succeeded. Unfortunately, Debian 7's udev does not work
> with 2.6.28...

I guess you will have many other issues too if you want to run
such combination (legacy kernel + modern userspace). E.g. current glibc
requires >= 2.6.32.

A.
