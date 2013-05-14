Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab3ENPEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:04:33 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:47285 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab3ENPEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:04:31 -0400
MIME-Version: 1.0
In-Reply-To: <874ne5n6zv.fsf@octavius.laptop.org>
References: <1368517100-22243-1-git-send-email-adam.lee@canonical.com>
	<20130514075333.GA22435@adam-laptop>
	<874ne5n6zv.fsf@octavius.laptop.org>
Date: Tue, 14 May 2013 08:04:29 -0700
X-Google-Sender-Auth: BiG5cycNOWhzfatKhEa3F1Q5K5A
Message-ID: <CAD=FV=VF2cVMR+2p5BTidOPKV0kAqJVGRxWYV4WRPu6qjkE+Vw@mail.gmail.com>
Subject: Re: [PATCH] mmc: core: Add a capability for disabling mmc cards
From: Doug Anderson <dianders@chromium.org>
To: Chris Ball <cjb@laptop.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nico@fluxnic.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Johan Rudholm <johan.rudholm@stericsson.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris / Adam,

On Tue, May 14, 2013 at 4:19 AM, Chris Ball <cjb@laptop.org> wrote:
> This has already been NACKed by Nicolas:
>
> https://patchwork.kernel.org/patch/1359121/
>
> (At least, I think it has -- your forward doesn't include the patch
> itself.)

Yup, it got NAKed.  Unless something has changed I think that
interested parties will need to carry this as a local patch.

-Doug
