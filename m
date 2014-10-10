Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaJJImv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:42:51 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:64190 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaJJIms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <20141009160737.GE31987@roeck-us.net>
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
	<20141008231208.GB25134@roeck-us.net>
	<CACRpkdZHHPvJiYmAvYdGb01sKsSmkfuV+d4-skSePbFFEjYs2g@mail.gmail.com>
	<20141009160737.GE31987@roeck-us.net>
Date: Fri, 10 Oct 2014 10:42:47 +0200
Message-ID: <CACRpkdZ8RH78Nx5rNeRv0Z-_Pk0yyd9b8X9eqxgCUnv1nVos-Q@mail.gmail.com>
Subject: Re: pinctrl-msm build error on Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Josh Boyer <jwboyer@fedoraproject.org>, torvalds@linuxfoundation.org,
        Josh Cartwright <joshc@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2014 at 6:07 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> But then Linus ignored my pull request (so far), so maybe I did manage to
> upset him ;-).

Did you send it as a separate mail with [GIT PULL] in the Subject:?

Else that is likely the problem. He gets a lot of noise.

Yours,
Linus Walleij
