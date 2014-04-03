Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaDCONR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:13:17 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:60482 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaDCONQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:13:16 -0400
MIME-Version: 1.0
In-Reply-To: <1647754.qr1tAySXax@diego>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com>
	<2790002.5U2DHYmUbK@diego>
	<20140325194357.GA27520@gmail.com>
	<1647754.qr1tAySXax@diego>
Date: Thu, 3 Apr 2014 16:13:15 +0200
Message-ID: <CACRpkdZVhf0ewXtv4S+CFHAzBJ+tjKKChojbt52fb+dQLx2j7Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] pinctrl: rockchip: fix handling of first pinbank
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 12:56 AM, Heiko Stübner <heiko@sntech.de> wrote:

> Therefore I put together the following two patches to go on top of
> your patch and also make rockchip_set_mux honor this situation.

Both patches applied for fixes.

Yours,
Linus Walleij
