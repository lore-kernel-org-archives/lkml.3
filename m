Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab3H2Jpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 05:45:49 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:58273 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642Ab3H2Jps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 05:45:48 -0400
Date: Thu, 29 Aug 2013 11:46:36 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
Message-ID: <20130829114636.18a09c72@armhf>
In-Reply-To: <20130828131548.0009d613@skate>
References: <20130828113459.48ecbb34@armhf>
	<521DCD33.2070008@gmail.com>
	<20130828121943.1c8327ca@skate>
	<521DD057.4040208@gmail.com>
	<20130828131548.0009d613@skate>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 13:15:48 +0200
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> wrote:

> For what reason does the driver needs to know whether it's the instance
> 0 or instance 1 ? If it's needed for some specific reason, then there
> should probably be something like marvell,i2s-channel-id = <0> and
> marvell,i2s-channel-id = <1>.

It seems simpler to use aliases.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
