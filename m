Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3ISNeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:34:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60423 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3ISNeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:34:06 -0400
Message-ID: <1379597640.3347.18.camel@hornet>
Subject: Re: [PATCH 25/26] ARM: vexpress: remove custom .init_time hook
From: Pawel Moll <pawel.moll@arm.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 19 Sep 2013 14:34:00 +0100
In-Reply-To: <1379526839-14798-26-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1379526839-14798-26-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 19 Sep 2013 13:34:01.0253 (UTC) FILETIME=[E6A48550:01CEB53C]
X-MC-Unique: 113091914340301801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 18:53 +0100, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks. The call to versatile_sched_clock_init
> is moved to .init_early instead, were it is also for non-DT boards.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Jon Medhurst (Tixy) <tixy@linaro.org>

Acked-by: Pawel Moll <pawel.moll@arm.com>

Thanks!

Pawel


