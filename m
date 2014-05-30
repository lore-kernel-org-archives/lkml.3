Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaE3G0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:26:31 -0400
Received: from quechua.inka.de ([193.197.184.2]:57732 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaE3G0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:26:30 -0400
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 May 2014 02:26:30 EDT
Date: Fri, 30 May 2014 08:07:13 +0200
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] tracing: Print nasty banner when trace_printk() is in use
References: <20140528131440.2283213c@gandalf.local.home> <20140528172618.GB17220@pd.tnic> <20140528134120.3328605e@gandalf.local.home>
Organization: private Linux site, southern Germany
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
From: Olaf Titz <olaf@bigred.inka.de>
Message-ID: <E1WqFyD-0005jp-76@bigred.inka.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   *********************************************************
>   ** NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **

Is it really that bad to warrant this kind of warning? Not knowing
about the issue at all, I read from the original description that the
wastage is four pages of memory times number of CPU cores, which
shouldn't matter much except for small embedded systems.

Or does this something much scarier, like considerably slowing down
fast paths?

Olaf
