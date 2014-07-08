Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaGHRYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:24:39 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:40977 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaGHRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:24:38 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Tue, 8 Jul 2014 13:24:35 -0400
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Message-ID: <20140708172435.GW17765@csclub.uwaterloo.ca>
References: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
 <20140703184808.GD17769@csclub.uwaterloo.ca>
 <20140704181317.GE17769@csclub.uwaterloo.ca>
 <53BC2082.9090807@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BC2082.9090807@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 06:46:58PM +0200, Sebastian Andrzej Siewior wrote:
> I just managed to boot my dra7-evm on mainline. It crashed in
> serial_omap_runtime_resume(). Now that is fixed. The next post should
> have this fixed and work (at least on v3.16-rc).

Sounds good.  I am still stuck on 3.12 since I need xenomais well as a
few things I don't think has been merged from TI's tree yet.

-- 
Len Sorensen
