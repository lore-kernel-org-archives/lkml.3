Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab3LaJXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:23:40 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:41315 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3LaJXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:23:38 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoIiABiMwlJV5qhFPGdsb2JhbAANS4tRsXMBCYEsAwEBAQE4gloBAQEBAgF4AQULCyEMCg8JAwIBAgExFAYBDAEHAQGHeA2sA5psF48dBwqELAEDrVmBZyM
X-IronPort-AV: E=Sophos;i="4.95,580,1384297200"; 
   d="scan'208";a="525707759"
Message-ID: <52C28DC7.9020003@euromail.se>
Date: Tue, 31 Dec 2013 10:26:31 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Felipe F. Tonello" <eu@felipetonello.com>, linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/2] input: mt: Add helper function to send end events
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
In-Reply-To: <1388455601-17033-1-git-send-email-eu@felipetonello.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> Adds a helper function to send end touch events for active tracking ids.
> And also implements it in egalax driver.

What problematic scenario is this supposed to solve?

The 'release on suspend' is only an approximation to the 'close laptop' scenario,
it is certainly not correct in the coffee table case, for instance. Instead of
hardcoding this in the kernel, userland can easily detect long intervals
directly using the event time.

Unless there is already a reasonable mechanism in your user application which
deals with cases like this but fails to account for your particular problem
scenario, the patch will not be applied.

Thanks,
Henrik

