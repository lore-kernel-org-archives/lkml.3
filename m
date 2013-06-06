Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3FFTnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:43:43 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40801 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3FFTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:43:41 -0400
MIME-Version: 1.0
In-Reply-To: <1370291306-3276-1-git-send-email-wsa@the-dreams.de>
References: <1370291306-3276-1-git-send-email-wsa@the-dreams.de>
Date: Thu, 6 Jun 2013 22:43:41 +0300
Message-ID: <CAHp75Vcvhz892D4gytneptB4wLWPjfKmf5OXgnChXw338nLBAA@mail.gmail.com>
Subject: Re: [PATCH] pwm: devm: alloc correct pointer size
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 11:27 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> The allocated object should be the size of what the pointer is pointing
> to and not the size of the pointer itself.

All devm_* functions in this module use **ptr as a parameter (except
allocation).
May be we first should understand why it so?
If it wrong approach, than probably you have to change **ptr -> *ptr.
But without answer on first question I don't know if it proper solution or not.

--
With Best Regards,
Andy Shevchenko
