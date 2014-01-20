Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaATQIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:08:44 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:38709 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaATQIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:08:42 -0500
Message-ID: <1390234117.25903.0.camel@host5.omatika.ru>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
From: Sergei Ianovich <ynvich@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Date: Mon, 20 Jan 2014 20:08:37 +0400
In-Reply-To: <1389309176.32346.1.camel@host5.omatika.ru>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
	 <201312182210.30544.arnd@arndb.de>
	 <1387401646.31516.14.camel@host5.omatika.ru>
	 <201312190630.11087.arnd@arndb.de>
	 <1389309176.32346.1.camel@host5.omatika.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 03:12 +0400, Sergei Ianovich wrote:
> On Thu, 2013-12-19 at 06:30 +0100, Arnd Bergmann wrote:
> > This would work only if we can probe the devices behind the external
> > bus controller before the controller itsef has been set up, since
> > the initialization order can depend on a number of things but not
> > the bus hierarchy. It will also work if the code setting up the
> > bus controller can be guaranteed to run before we call
> > of_platform_populate for the regular devices, which is probably
> > the best solution here.
> 
> There has been no activity for 3 weeks. Could we resume the series?

It's over a month now. Is anything wrong?

