Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbbA2MsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 07:48:10 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34385 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbbA2MsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 07:48:07 -0500
MIME-Version: 1.0
In-Reply-To: <1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
References: <1421836341-2036-1-git-send-email-rebecca.swee.fun.chang@intel.com>
	<1421836341-2036-2-git-send-email-rebecca.swee.fun.chang@intel.com>
Date: Thu, 29 Jan 2015 13:48:05 +0100
Message-ID: <CACRpkdZE9akRDBmj2GNGMNxYFCAr=w8madmaV4xrQf8T2n-nkw@mail.gmail.com>
Subject: Re: [PATCH 1/1] gpio: sch: Consolidate similar algorithms
From: Linus Walleij <linus.walleij@linaro.org>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 11:32 AM, Chang Rebecca Swee Fun
<rebecca.swee.fun.chang@intel.com> wrote:

> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
>
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>

Applied again, with the review-tags.

Yours,
Linus Walleij
