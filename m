Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab3E0MH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:07:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52117 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3E0MH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:07:58 -0400
Date: Mon, 27 May 2013 13:07:53 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 1/2] clocksource: dw_apb: remove unused header
Message-ID: <20130527120753.GB3048@maple>
References: <1369570367-994-1-git-send-email-baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369570367-994-1-git-send-email-baruch@tkos.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 03:12:46PM +0300, Baruch Siach wrote:
> The time.h header seems not to be used by current code. Removing this include
> allows the driver to build on other architecture that do not have this header.
> 
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jamie Iles <jamie@jamieiles.com>

Acked-by: Jamie Iles <jamie@jamieiles.com>
