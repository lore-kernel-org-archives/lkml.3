Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3KVJkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:40:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517Ab3KVJkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:40:03 -0500
Message-ID: <1385113201.4946.6.camel@linux-fkkt.site>
Subject: Re: DisplayLink driver
From: Oliver Neukum <oneukum@suse.de>
To: Alejandro Bonilla <abonilla@linuxwireless.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 22 Nov 2013 10:40:01 +0100
In-Reply-To: <CA+tRDaL=RSjG=Fdw4+6hia8WWM5oa_JoZBA+HFOA6mgqTunb0A@mail.gmail.com>
References: <CA+tRDaL=RSjG=Fdw4+6hia8WWM5oa_JoZBA+HFOA6mgqTunb0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-21 at 20:41 -0500, Alejandro Bonilla wrote:

> But xrandr is not recognizing the device/screen.
> 
> So the question is, which driver supports it, the UDL or UDLFB driver?

udl is necessary.

	HTH
		Oliver


