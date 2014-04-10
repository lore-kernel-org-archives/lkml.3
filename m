Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030359AbaDJLJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:09:21 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38660 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030226AbaDJLJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:09:18 -0400
Date: Thu, 10 Apr 2014 12:08:52 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140410120852.553449ae@alan.etchedpixels.co.uk>
In-Reply-To: <3028945.75TnRQEiiW@ws-stein>
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com>
	<2205089.MXSpGW1NLo@ws-stein>
	<20140409151822.GA21864@roeck-us.net>
	<3028945.75TnRQEiiW@ws-stein>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We'll see if and what will be accepted upstream.
> 
> As far as I can see, CONFIG_OF is only selected if a specific hardware is enabled.

For conventional PC it makes no sense. For non conventional devices -
well Kconfig is also convered by the GPL ;-)

Alan
