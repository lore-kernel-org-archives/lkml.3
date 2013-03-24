Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab3CXK1i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 06:27:38 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42911 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3CXK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 06:27:37 -0400
Message-ID: <514ED516.4020009@acm.org>
Date: Sun, 24 Mar 2013 11:27:34 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Fredrik Tolf <fredrik@dolda2000.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: I/O blocked while dirty pages are being flushed
References: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com>
In-Reply-To: <alpine.DEB.2.02.1303240543280.4028@shack.dolda2000.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/13 06:12, Fredrik Tolf wrote:
> While this flush is running, I find that many a process goes into disk
> sleep waiting for the flush to complete. This includes the process
> manipulating the mmapped file whenever it tries to redirty a page
> currently waiting to be flushed, but also, for instance, programs that
> write() to log files (since, I guess, the buffer page backing the last
> written portion of the log file is being flushed).

Had you already encountered this article: Jonathan Corbet, The trouble 
with stable pages, March 13, 2012 (http://lwn.net/Articles/486311/) ?

Bart.
