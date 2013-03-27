Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3C0SAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:00:05 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:47332 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3C0SAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:00:02 -0400
MIME-Version: 1.0
In-Reply-To: <87ip4cbu87.fsf@octavius.laptop.org>
References: <1364338202-10311-1-git-send-email-grundler@chromium.org>
	<000b01ce2ae6$249bfb90$6dd3f2b0$%jun@samsung.com>
	<CANEJEGsLqAdZqLV+c59nT97ErdAOSRWTPJpYye7m64_i7ga0rg@mail.gmail.com>
	<87ip4cbu87.fsf@octavius.laptop.org>
Date: Wed, 27 Mar 2013 11:00:01 -0700
X-Google-Sender-Auth: 6aR2UnPaEg55ChNNCrOpe5t5NvI
Message-ID: <CANEJEGuvz5tp6t3MZmeAUt16XLap7tMuws6WxjrcrdDN_5Y=Uw@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: rewrite CLKDIV computation
From: Grant Grundler <grundler@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Will Newton <will.newton@gmail.com>, Bing Zhao <bzhao@marvell.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ashok Nagarajan <asnagarajan@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Wed, Mar 27, 2013 at 10:58 AM, Chris Ball <cjb@laptop.org> wrote:
> Hi Grant,
...
> Please use the following (standard) syntax in the commit message:
>
> Commit e419990b5e8 ("mmc: dw_mmc: correct the calculation for CLKDIV")
> fixed a bug in CLKDIV computation.  [..]

Ok - I didn't know that was "standard". But easy enough to do.

cheers,
grant
