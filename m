Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaHUMGo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:06:44 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39473 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaHUMGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:06:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140821091819.GA2230@msilap.einon.net>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
	<1408573078-9320-6-git-send-email-mark.einon@gmail.com>
	<CAOMZO5Du34=jpr5B_fHGZ+D_jNR0VSDy2BiO6jj8QByh7V40RQ@mail.gmail.com>
	<20140821091819.GA2230@msilap.einon.net>
Date: Thu, 21 Aug 2014 09:06:40 -0300
Message-ID: <CAOMZO5DYppH8kURS-eGk9sTD-CfBYt4hWQehKE01Hj=1JXMAdg@mail.gmail.com>
Subject: Re: [PATCH 5/8] staging: et131x: Remove unnecessary i2c_wack variable
From: Fabio Estevam <festevam@gmail.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Aug 21, 2014 at 6:18 AM, Mark Einon <mark.einon@gmail.com> wrote:

>
> Hi Fabio, thanks for the review.
>
> It's a space alignment of parameters to go with the previous change, to
> keep wrapping consistent in the file:
>
> -       while (i2c_wack) {
> +       while (1) {
>                 if (pci_write_config_byte(pdev, LBCIF_CONTROL_REGISTER,
> -                       LBCIF_CONTROL_LBCIF_ENABLE))
> +                                         LBCIF_CONTROL_LBCIF_ENABLE))
>
> So what are you saying - are you just commenting, document it, put it
> in a seperate patch?

Yes, it would be better if this part was part of a separate patch.
