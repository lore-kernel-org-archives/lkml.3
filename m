Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbaDHLRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 07:17:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35712 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaDHLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 07:16:59 -0400
Date: Tue, 8 Apr 2014 12:16:38 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: goldfish: Call free_irq in error path
Message-ID: <20140408121638.542c15c8@alan.etchedpixels.co.uk>
In-Reply-To: <1396937722-330-1-git-send-email-tuomas.tynkkynen@iki.fi>
References: <1396937722-330-1-git-send-email-tuomas.tynkkynen@iki.fi>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Apr 2014 09:15:22 +0300
Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi> wrote:

> If misc_register failed in goldfish_audio_probe, the already requested
> IRQ wouldn't get freed. Add a call to free_irq() like there is in
> goldfish_audio_remove().
> 
> Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>

Acked-by: Alan Cox <alan@linux.intel.com>
