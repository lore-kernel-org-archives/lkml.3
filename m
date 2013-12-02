Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3LBMBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:01:14 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:45356 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3LBMBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:01:12 -0500
Message-ID: <1385985668.12531.31.camel@host5.omatika.ru>
Subject: Re: [PATCH 05/11] serial: support for 16550 serial ports on LP-8x4x
From: Sergei Ianovich <ynvich@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Date: Mon, 02 Dec 2013 16:01:08 +0400
In-Reply-To: <20131202115226.GI16735@n2100.arm.linux.org.uk>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <1385879185-22455-6-git-send-email-ynvich@gmail.com>
	 <20131202113052.GG16735@n2100.arm.linux.org.uk>
	 <1385984366.12531.24.camel@host5.omatika.ru>
	 <20131202115226.GI16735@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-02 at 11:52 +0000, Russell King - ARM Linux wrote:
> Add a new enum.

I will. Thanks for prompt replies.

A side work process question:
Should I respin this single patch?

Or should I wait for other patch reviews and respin the whole series
when ready?



