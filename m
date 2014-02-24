Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaBXKW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:22:56 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:64853 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaBXKWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:22:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140223154053.GN7862@titan.lakedaemon.net>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20140223154053.GN7862@titan.lakedaemon.net>
Date: Mon, 24 Feb 2014 11:22:51 +0100
Message-ID: <CACRpkdZFwcFtZiDH792awhyrQ6wtEsJMMN9K_ypCbqLqZo9LLw@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] pinctrl: mvebu: restructure resource allocation
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 4:40 PM, Jason Cooper <jason@lakedaemon.net> wrote:

> I certainly don't want to assume we can take this, and you've been quiet
> on the previous versions of this series.  We have a lot of moving pieces
> for getting the Armada 375/380/385 support added to the kernel.  It's a
> huge help to us if we can create a topic branch for you with the pinctrl
> changes in it.

I understand, sorry I was on a short vacation.

I've applied Thomas' two new SoC drivers and started queueing
Sebastians series but it's a bit messy. Right now I'm not finding
patch 06/21 v4....

>> https://github.com/shesselba/linux-dove.git unstable/mvebu-pinctrl-v3.14_v4

Should I just pull this in instead, as it contains both Thomas' and Sebastians
patches, and then you can send me more stuff on top of that?

Yours,
Linus Walleij
