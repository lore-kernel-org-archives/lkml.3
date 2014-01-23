Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaAWHhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:37:02 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63577 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWHg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:36:59 -0500
MIME-Version: 1.0
In-Reply-To: <1389972601-27164-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1389917951-13100-1-git-send-email-david.a.cohen@linux.intel.com>
	<1389972601-27164-1-git-send-email-david.a.cohen@linux.intel.com>
Date: Thu, 23 Jan 2014 08:36:59 +0100
Message-ID: <CACRpkdYx28sXC7SLEyTi+kNYdQ_KDvGY_7XSPsqx7dvSsJ-mwA@mail.gmail.com>
Subject: Re: [PATCH v2] gpio: intel-mid: comments cleanup
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 4:30 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> This is a simple cleanup on gpio-intel-mid.c's header comments.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Applied, but I changed it like this:

> - * Copyright (c) 2008, 2009, 2013, Intel Corporation.
> + * Copyright (c) 2014 Intel Corporation.

To-> Copyright (c) 2008-2014

Yours,
Linus Walleij
