Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbaE3JjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:39:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:51860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbaE3JjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:39:18 -0400
Message-ID: <538851C3.80401@linutronix.de>
Date: Fri, 30 May 2014 11:39:15 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 2/2] perf script: handle the num array type in python
 properly
References: <1401207274-8170-1-git-send-email-bigeasy@linutronix.de>	<1401207274-8170-2-git-send-email-bigeasy@linutronix.de> <87d2exgpp3.fsf@sejong.aot.lge.com>
In-Reply-To: <87d2exgpp3.fsf@sejong.aot.lge.com>
X-Enigmail-Version: 1.6+git0.20140323
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 06:43 AM, Namhyung Kim wrote:
> But this requires a change in generation time as I faced a type error
> when try to print an array argument as number.  I'll post a separate
> patch for this.

Thank you.

> 
> Thanks,
> Namhyung
> 
Sebastian
