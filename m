Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab3HWUpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:45:36 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:59350 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748Ab3HWUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:45:35 -0400
Date: Fri, 23 Aug 2013 16:45:33 -0400 (EDT)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Message-ID: <169123028.921974.1377290733515.JavaMail.root@mail>
In-Reply-To: <20130823201149.GA5640@katana>
Subject: Re: [PATCH] misc: (at24) move header to linux/platform_data/
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - GC28 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram wrote:

> > IMHO it makes sense. Why wouldn't we want all platform_data in
> > include/linux/platform_data/?
> 
> For the same reason we don't want all driver source files in one
> directory? It's a mess.

Well, that's different. Not all drivers expose platform data, but many
subsystems have drivers with platform data. A common include directory
for the *_platform_data structure definitions makes sense.

Regards,
Vivien
