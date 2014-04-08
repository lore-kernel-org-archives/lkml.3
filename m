Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbaDHOWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:22:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:11378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbaDHOWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:22:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,818,1389772800"; 
   d="scan'208";a="516893064"
Message-ID: <1396965172.30750.0.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ubi: avoid workqueue format string leak
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Kees Cook <keescook@chromium.org>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Apr 2014 16:52:52 +0300
In-Reply-To: <20140408044407.GA13141@www.outflux.net>
References: <20140408044407.GA13141@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 21:44 -0700, Kees Cook wrote:
> When building the name for the workqueue thread, make sure a format
> string cannot leak in from the disk name.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Pushed to linux-ubifs / master, thanks!

-- 
Best Regards,
Artem Bityutskiy

