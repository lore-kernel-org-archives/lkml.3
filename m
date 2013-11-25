Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3KYQdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:33:02 -0500
Received: from relay.parallels.com ([195.214.232.42]:47923 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3KYQdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:33:00 -0500
Message-ID: <52937BB9.9070703@parallels.com>
Date: Mon, 25 Nov 2013 20:32:57 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: CRIU <criu@openvz.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [Announce] Checkpoint-restore tool v1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm very proud to announce the first major release of the C/R tool!

About two months ago the lasts required kernel patch has found its
way upstream. Since then we have concentrated on the tool itself
making it work reliably and with as little ugly hacks as possible :)

Right now it looks like the project is not just the "proof of concept"
thing any more :)

I'd also like to thank again all the people why participated in the
discussions and development, the community help is the great part of
what made this release happen!


What we have now:
* sources @ http://download.openvz.org/criu/criu-1.0.tar.bz2
* full history @ http://git.criu.org/?p=crtools.git
* docs, plans and more @ http://criu.org/
* news @ https://plus.google.com/+CriuOrg


Have fun and stay tuned!

Thanks,
Pavel
