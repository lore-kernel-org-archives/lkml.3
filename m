Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaAIXNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:13:11 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:47641 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaAIXNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:13:01 -0500
Message-ID: <1389309176.32346.1.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Fri, 10 Jan 2014 03:12:56 +0400
In-Reply-To: <201312190630.11087.arnd@arndb.de>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312182210.30544.arnd@arndb.de>
	 <1387401646.31516.14.camel@host5.omatika.ru>
	 <201312190630.11087.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 06:30 +0100, Arnd Bergmann wrote:
> This would work only if we can probe the devices behind the external
> bus controller before the controller itsef has been set up, since
> the initialization order can depend on a number of things but not
> the bus hierarchy. It will also work if the code setting up the
> bus controller can be guaranteed to run before we call
> of_platform_populate for the regular devices, which is probably
> the best solution here.

There has been no activity for 3 weeks. Could we resume the series?


