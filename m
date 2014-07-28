Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaG1C0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 22:26:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:42392 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbaG1C0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 22:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,745,1400050800"; 
   d="scan'208";a="579823194"
Message-ID: <1406514389.14109.7.camel@rzhang1-toshiba>
Subject: Re: [PATCH v5 3/6] thermal: Added Bang-bang thermal governor
From: Zhang Rui <rui.zhang@intel.com>
To: Peter Feuerer <peter@piie.net>
Cc: linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Mohr <andi@lisas.de>, Borislav Petkov <bp@suse.de>,
        Javi Merino <javi.merino@arm.com>
Date: Mon, 28 Jul 2014 10:26:29 +0800
In-Reply-To: <cone.1406384086.541895.7413.1000@galar>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
	 <1406043436-17068-1-git-send-email-peter@piie.net>
	 <1406043436-17068-4-git-send-email-peter@piie.net>
	 <cone.1406384086.541895.7413.1000@galar>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-26 at 16:14 +0200, Peter Feuerer wrote:
> Hi Rui,
> 
> Peter Feuerer writes:
> 
> > The bang-bang thermal governor uses a hysteresis to switch abruptly on
> > or off a cooling device.  It is intended to control fans, which can
> > not be throttled but just switched on or off.
> > Bang-bang cannot be set as default governor as it is intended for
> > special devices only.  For those special devices the driver needs to
> > explicitely request it.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> 
> Anything that prevents you from giving your acked-by?
> 
NO.

I'll queue them for 3.18.

thanks,
rui

