Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaHTWW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:22:59 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37225 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaHTWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <1408573078-9320-6-git-send-email-mark.einon@gmail.com>
References: <1408573078-9320-1-git-send-email-mark.einon@gmail.com>
	<1408573078-9320-6-git-send-email-mark.einon@gmail.com>
Date: Wed, 20 Aug 2014 19:22:54 -0300
Message-ID: <CAOMZO5Du34=jpr5B_fHGZ+D_jNR0VSDy2BiO6jj8QByh7V40RQ@mail.gmail.com>
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

On Wed, Aug 20, 2014 at 7:17 PM, Mark Einon <mark.einon@gmail.com> wrote:

>                         do {
>                                 pci_read_config_dword(pdev,
> -                                       LBCIF_DATA_REGISTER, &val);
> +                                                     LBCIF_DATA_REGISTER,
> +                                                     &val);

This seems to be an unrelated change.
