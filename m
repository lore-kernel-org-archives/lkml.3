Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3ENM4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:56:33 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51228 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab3ENM4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:56:32 -0400
MIME-Version: 1.0
In-Reply-To: <1368173847-5661-20-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-20-git-send-email-wsa@the-dreams.de>
Date: Tue, 14 May 2013 14:56:31 +0200
Message-ID: <CACRpkdYoDqsyE-oX5pBYx6v3txn=OjTLPoQOKkqaSLA5FNjYXw@mail.gmail.com>
Subject: Re: [RFC 19/42] drivers/pinctrl/spear: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        spear-devel <spear-devel@list.st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:17 AM, Wolfram Sang <wsa@the-dreams.de> wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Patch applied with Viresh's ACK.

Thanks!
Linus Walleij
