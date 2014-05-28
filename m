Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaE1NSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:18:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbaE1NSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:18:20 -0400
Date: Wed, 28 May 2014 06:16:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 0/5] efuse driver for Tegra
Message-Id: <20140528061645.252c2fbc.akpm@linux-foundation.org>
In-Reply-To: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
References: <1401281677-32110-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 15:54:32 +0300 Peter De Schrijver <pdeschrijver@nvidia.com> wrote:

> This driver allows userspace to read the raw efuse data.

The patchset uses an inexplicable mixture of "fuse" and "efuse".
Given that the kernel already has a "fuse", it would be nice if
this code could use "efuse" everywhere.
