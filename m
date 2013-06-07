Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab3FGI1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:27:40 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:51654 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3FGI1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:27:37 -0400
Date: Fri, 7 Jun 2013 10:27:25 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: NULL pointer dereference when loading the gre module (3.10.0-rc4)
Message-ID: <20130607082725.GA15083@uio.no>
References: <20130606221656.GA11475@uio.no>
 <20130607030648.GA28618@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130607030648.GA28618@home.goodmis.org>
X-Operating-System: Linux 3.10.0-rc4 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 11:06:48PM -0400, Steven Rostedt wrote:
> Note the faulting address is 0xffffffffa0e52001, which is around the
> above address, be interesting to know what was at that location.

Is there any way I can figure this out? The machine in question is still
running. kallsyms doesn't show anything near it, though.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
