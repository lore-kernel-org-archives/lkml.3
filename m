Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaBTKSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:18:07 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:41862 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957AbaBTKSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:18:05 -0500
X-Yandex-Uniq: 8d8ea1a4-51b0-4ebf-a25e-7d734c5c5d28
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Thu, 20 Feb 2014 14:17:58 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Dan Williams <dan.j.williams@intel.com>
Cc: dmaengine@vger.kernel.org, Mike Galbraith <bitbucket@online.de>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ioat: fix tasklet tear down
Message-ID: <20140220101758.GC3487@stfomichev-desktop.yandex.net>
References: <20140220071145.21609.89019.stgit@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220071145.21609.89019.stgit@viggo.jf.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Passes my testing, but would appreciate a tested-by.
Tested-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
