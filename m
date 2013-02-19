Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab3BSGq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 01:46:56 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37661 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3BSGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 01:46:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ8diHTq6ayQjciiu_9fXyHYTk4DorT=5uw=759zHo7B81-e4w@mail.gmail.com>
References: <CAJ8diHTq6ayQjciiu_9fXyHYTk4DorT=5uw=759zHo7B81-e4w@mail.gmail.com>
Date: Tue, 19 Feb 2013 12:16:54 +0530
Message-ID: <CAJ8diHT5Ze3bsPGO7yLqPHu6niuDC_gtjJB=gKGoUXOfvoHtyw@mail.gmail.com>
Subject: Fwd: mmc card probe not getting called
From: chetan cr123 <chetancr123@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI All,

I am working on Sd Card/Block driver

I am registering it as both

1. register_blkdev()-------------  BLOCK Regsiter
2. mmc_register_driver ------  MMC regsiter

and filling the mmc_driver structure.

I am not able to see the probe of MMC, But i see the return value of
mmc_register function returning success.

Kindly let me know how i make the probe of mmc getting called

Thanks


Chetan
