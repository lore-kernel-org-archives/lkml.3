Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3FCFFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 01:05:30 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52508 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3FCFFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 01:05:22 -0400
MIME-Version: 1.0
In-Reply-To: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 3 Jun 2013 10:35:21 +0530
Message-ID: <CAKohpo=5+6X79tJaHd0BvKzECNqpiUcp9eybSSMDcJCkF8HVng@mail.gmail.com>
Subject: Re: [RFC PATCH v0 0/2] dw_dmac: move to own folder and split
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2013 21:20, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> This is first attempt to do split as suggested by Arnd et al.
> First patch moves driver to its own folder.
> Second one does the actual split.
>
> During this files are renamed: mostly means that dw_dmac prefix is eliminated.
> I hope to get it ready to be included in v3.11.

Couldn't find any obvious mistake in your patch other than minor
comment on 1/2 (it stays valid for 2/2 as well)..

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
