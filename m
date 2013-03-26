Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3CZRQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:16:41 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:42036 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3CZRQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:16:40 -0400
MIME-Version: 1.0
In-Reply-To: <1364317922.6652.34.camel@smile>
References: <5151B91B.7060404@metafoo.de>
	<1364317484-30005-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAKohpoksxVo3fFdaqOBucOzJs_aU3XGiTcM3b6GzW=m=ooFzQQ@mail.gmail.com>
	<1364317922.6652.34.camel@smile>
Date: Tue, 26 Mar 2013 22:46:39 +0530
Message-ID: <CAKohponTj8iHTZqs2pS9m1mOqgbGX5WUDa7B2-xcDP_0sN7ZsQ@mail.gmail.com>
Subject: Re: [PATCH v2.1] dw_dmac: make wrapper on of_dma_controller_register()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 22:42, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Nowadays, besides removal of the -ENODEV checking, it makes probe
> function looks tidier.

Removal of -ENODEV is okay but am not sure if it makes code good :)

This is unnecessary abstraction for just calling a single routine. If that
part was bigger, i would have agreed but to me this wrapper is just
adding abstraction and nothing more.

--
viresh
