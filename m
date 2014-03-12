Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaCLOKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:10:35 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52723 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaCLOKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
References: <1394174686-8358-1-git-send-email-sboyd@codeaurora.org>
Date: Wed, 12 Mar 2014 15:10:32 +0100
Message-ID: <CACRpkda4jDynsd_FDyOdbO03V4CHMo57z6xP_3W2OSKwV=18gQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] pinctrl-msm cleanups
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 7:44 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Here are some small fixes and cleanups for the msm pinctrl
> driver.

Okay, applied all 7 patches with Björn's ACK.

I had to use some fuzzing on patch 5 so please check the
end result in linux-next.

Yours,
Linus Walleij
