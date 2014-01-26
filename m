Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaAZSdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 13:33:44 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:34902 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbaAZSdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 13:33:43 -0500
Message-ID: <52E554EC.3090900@ladisch.de>
Date: Sun, 26 Jan 2014 19:33:16 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Network Nut <sillystack@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: WaitForMultipleObjects/etc. In Kernel
References: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com>
In-Reply-To: <00d901cf1a19$0ea62db0$2bf28910$@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Network Nut wrote:
> I think that the facility by which a thread can block while waiting for any
> of several synchronization primitives (*mutex*, *semaphore*, *event*, *waitable
> timer*)...is not only "nice to have", but fundamental to complex (clean)
> multi-threaded programming.

You mean a facility like (e)poll, which can wait for things like timerfd,
signalfd, or eventfd?


Regards,
Clemens
