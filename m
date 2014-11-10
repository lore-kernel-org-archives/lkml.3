Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaKJSyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:54:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:41912 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbaKJSyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:54:04 -0500
MIME-Version: 1.0
In-Reply-To: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org>
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 10 Nov 2014 10:54:00 -0800
Message-ID: <CAMAWPa_f1K1qUG_UTmM0w8Sz8wed7+CQkK9tc8t1W=CTJvdjyw@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
From: Kevin Hilman <khilman@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Tyler Baker <tyler.baker@linaro.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 5:33 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> We rely on probe order of this driver to determine the line number for
> the uart port. This makes it impossible to know the line number
> when these devices are populated via DT. Use the DT alias
> mechanism to assign the line based on the aliases node.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

FYI... this patch hit linux-next and caused multiple boot failures on
qcom platforms[1] as of next-20141110.  I'm assuming this is because
the corresponding DTS changes have not hit linux-next yet.

Kevin

[1] http://status.armcloud.us/boot/?qcom
