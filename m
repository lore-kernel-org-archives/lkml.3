Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaIQJFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:05:13 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60086 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbaIQJFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:05:10 -0400
Date: Wed, 17 Sep 2014 11:05:06 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
Message-ID: <20140917090506.GA6812@breakpoint.cc>
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-10 21:29:55 [+0200], Sebastian Andrzej Siewior wrote:
> the diff of v8…v9 is small:

Greg, do you mind taking patches from this series up to "[PATCH 05/16]"?
Nobody complained about those so far and it would keep v10 a little smaller.
I have changes to #6 (the omap driver) and need to do some DMA related
changes in the following

Sebastian
