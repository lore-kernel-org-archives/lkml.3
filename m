Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaDTP25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 11:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463AbaDTP2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 11:28:17 -0400
Message-ID: <1398007690.2674.0.camel@adam.happyassassin.net>
Authentication-Results: mail.happyassassin.net; dmarc=none header.from=redhat.com
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on
 ASUS T100TA
From: Adam Williamson <awilliam@redhat.com>
To: "Jin, Yao" <yao.jin@linux.intel.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Sun, 20 Apr 2014 08:28:10 -0700
In-Reply-To: <5353B8A4.1080900@linux.intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	 <CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	 <5353A1F6.60602@linux.intel.com> <5353B8A4.1080900@linux.intel.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-20 at 20:08 +0800, Jin, Yao wrote:
> For the issue that touch screen doesn't work, could you check power
> state of LPSS devices? For example:
> 
> cd /sys/bus/acpi/devices
> grep -H . */power_state
> 
> If they are D3cold, it should be the reason why touch screen doesn't
> work. That's another issue, unrelated to this gpio patch.

The touch screen worked fine with kernel 3.14, and Benjamin looked at
debug output from the attempt to load the touchscreen driver when
diagnosing the problem, he's not just guessing. I am building a kernel
without your patch to confirm that fixes it.
-- 
Adam Williamson
Fedora QA Community Monkey
IRC: adamw | Twitter: AdamW_Fedora | XMPP: adamw AT happyassassin . net
http://www.happyassassin.net

