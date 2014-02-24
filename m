Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaBXKFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:05:23 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40829 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbaBXKFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:05:21 -0500
MIME-Version: 1.0
In-Reply-To: <1393165274-32492-3-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1393165274-32492-3-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 24 Feb 2014 11:05:21 +0100
Message-ID: <CACRpkdavoRVSHS8bDUAiMuV=89gx3MoFo_MUgGRWC-YJQFukxA@mail.gmail.com>
Subject: Re: [PATCH v4 02/16] pinctrl: mvebu: remove obsolete per-control name
 buffer allocation
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 3:21 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> With the introduction of a global name buffer, we can now remove
> the allocation and preparation of per-control name buffers.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Patch applied.

Yours,
Linus Walleij
