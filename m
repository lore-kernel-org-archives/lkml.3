Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaGJOo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:44:29 -0400
Received: from sasl.smtp.pobox.com ([208.72.237.25]:58382 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaGJOo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:44:26 -0400
X-Greylist: delayed 806 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 10:44:26 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=mime-version
	:in-reply-to:references:date:message-id:subject:from:to:cc
	:content-type; q=dns; s=sasl; b=E5LcqTCgbGm/VB7dOHqEHN7SrVfRXLmf
	2botf/ApXt3rbMUp6XxTVasMr8hrOH3SfH4UHLYsZ/Lmea7fIXflB2ggu5ik7SEa
	QsovDQETl7Uio4UQfg90Dvz3wTtVckQmRu7+TKyo0LZi1cNhf8xuWVn68AQkI1Bg
	oej4gMPSuBE=
MIME-Version: 1.0
In-Reply-To: <1404928177-26554-2-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
	<1404928177-26554-2-git-send-email-bigeasy@linutronix.de>
Date: Thu, 10 Jul 2014 16:30:43 +0200
Message-ID: <CAMFK0gtLHrYzWipw=9rp-cUZrKkzBAn_iXSetn016F7zvuZE0w@mail.gmail.com>
Subject: Re: [PATCH 1/6] tty: serial: 8250 core: provide a function to export uart_8250_port
From: Olivier Galibert <galibert@pobox.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-Pobox-Relay-ID: BDB0494E-083E-11E4-A057-7FB96395E023-92059326!pb-sasl0.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 7:49 PM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> + * The lock assumption made here is none because runtime-pm suspend/resume
> + * callbacks should not be invoked there is any operation performed on the port.

I think there's a missing "if"?

Best,

  OG.
