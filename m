Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaBKPaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:30:19 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:55272 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaBKPaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:30:16 -0500
Message-ID: <52FA41FA.6030908@ahsoftware.de>
Date: Tue, 11 Feb 2014 16:30:02 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: work unwinding?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since the kernel has become more RT-aware and many stuff has moved into
works, dump_stack() has often become a bit useless, because it just
shows the call stack of a work, which quiet often is a bit short and
doesn't reveal the real source of a problem.

At least I would like it if there would be some mechanism to record the
call stack for works, so that dump_stack() could display what actually
queued a work (and it's call stack).

Not that I want to implement such, I'm just curious if someone already
has thought about implementing something like that, which I'm calling
here "work unwinding" ;)

Regards,

Alexander Holler
