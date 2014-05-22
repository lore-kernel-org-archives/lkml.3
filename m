Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaEVVw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:52:28 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61854 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaEVVw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <1400231909-7662-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1400231909-7662-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Thu, 22 May 2014 23:52:26 +0200
Message-ID: <CACRpkdZppbNKiwWuM1f_17BT0fPv3fv7U=AVtY=gntmf3L1k8w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: baytrail: Add pull type, strength and open drain
 to debugfs output
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sundar Iyer <sundar.iyer@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:18 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> In case of resolving power management or similar issues it might be useful
> to have these properties included in the debugfs output.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied with Mathias' ACK.

Yours,
Linus Walleij
