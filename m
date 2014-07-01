Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbaGAQCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:02:53 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:51424 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaGAQCw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:02:52 -0400
Date: Tue, 1 Jul 2014 18:04:26 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701180426.54a79a0b@armhf>
In-Reply-To: <20140701133627.GP32514@n2100.arm.linux.org.uk>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140701131026.GO32514@n2100.arm.linux.org.uk>
	<53B2B5E5.50502@gmail.com>
	<20140701133627.GP32514@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014 14:36:27 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> The Armada DRM stuff shouldn't be a problem, but the TDA998x may end up
> being so /if/ Jean-Francois decides to object to my approach there to
> allow tilcdc to continue working with the driver... but then as I now
> maintain that as well, that's not much of an issue because I can make
> the decision to overrule that point.

I proposed a patch to move the tda998x from a slave_encoder to a simple
encoder/connector. This patch included the associated changes to the
tilcdc. It has been violently refused. So, I will keep out of tree my
tda998x and Dove DRM drivers.

Now, the last thing for me is to put the TDA998x codec in the kernel
(it is also working in an other machine with 2 tda998x's).

So, you may do what you want...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
