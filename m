Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbaCNQZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:25:41 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:36960 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaCNQZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <1394812687-12715-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1394456094-21671-6-git-send-email-mika.westerberg@linux.intel.com>
	<1394812687-12715-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 14 Mar 2014 17:25:39 +0100
Message-ID: <CACRpkdYyBgL0W5cYpAEQZzc7u5K4yEBOr5hD5gDFFPBYvxkgqQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] gpio / ACPI: Add support for ACPI GPIO operation regions
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 4:58 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> GPIO operation regions is a new feature introduced in ACPI 5.0
> specification. This feature adds a way for platform ASL code to call back
> to OS GPIO driver and toggle GPIO pins.

OK this version of the patch applied!

Yours,
Linus Walleij
