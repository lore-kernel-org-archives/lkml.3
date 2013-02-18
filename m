Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3BRLzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:55:55 -0500
Received: from plane.gmane.org ([80.91.229.3]:38505 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3BRLzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:55:54 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el.es.cr@gmail.com>
Subject: Re: Stupid user with user-space questions, matrix LED driving with user space code only.
Date: Mon, 18 Feb 2013 11:55:38 +0000 (UTC)
Message-ID: <loom.20130218T124824-843@post.gmane.org>
References: <1361025476.4271.36.camel@jonspc>  <1361082134.16206.24.camel@anish-Inspiron-N5050>  <1361111844.14757.29.camel@jonspc>  <20130218020557.GA27667@kroah.com> <1361163968.29540.62.camel@jonspc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.148.108.228 (Mozilla/5.0 (Windows NT 5.1; rv:18.0) Gecko/20100101 Firefox/18.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Andrews <jon <at> jonshouse.co.uk> writes:


> 
> What about a yield alignment mechanism for user space. IE the process
> calls the kernel with a request "schedule me first after a yeild" - then
> the process at least has whatever the timer granularity is to do
> something timing critical... add a flag to ignore or defer interrupts
> and you have a semi 'hard-realtime' behaviour for user space, allowing
> user space to grab small chunks of real time. Yes a nasty looking
> facility for SMP intel servers but really useful for embedded.
> 

Seems you have some (bad?) habits from embedded programming, 
you think Linux is FreeRTOS ;)

Linux as such, as far as I read, is not a real-time OS, it will 
NOT do what you want in userspace, (maybe unless you build it with
the RT patchset?)

Better take the advice and go build a kernel driver for this display.

Or use a small microcontroller that won't have the limitations. 

> Thanks,
> Jon
> 
> 
Lukasz



