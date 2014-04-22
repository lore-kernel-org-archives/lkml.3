Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaDVPqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:46:16 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:49379 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaDVPqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:46:12 -0400
MIME-Version: 1.0
In-Reply-To: <1398180489-20230-4-git-send-email-alchark@gmail.com>
References: <1390823503-24087-1-git-send-email-alchark@gmail.com>
	<1398180489-20230-1-git-send-email-alchark@gmail.com>
	<1398180489-20230-4-git-send-email-alchark@gmail.com>
Date: Tue, 22 Apr 2014 10:46:11 -0500
Message-ID: <CAL_JsqJQMGqESyAt=-fY90jF61vJjVzcfXQZ9fxtbPhadnC=UA@mail.gmail.com>
Subject: Re: [PATCH 3/3] net: via-rhine: add OF bus binding
From: Rob Herring <robherring2@gmail.com>
To: Alexey Charkov <alchark@gmail.com>
Cc: Roger Luethi <rl@hellgate.ch>, netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>, Rob Herring <robh+dt@kernel.org>,
        David Miller <davem@davemloft.net>, ben@decadent.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:28 AM, Alexey Charkov <alchark@gmail.com> wrote:
> This should make the driver usable with VIA/WonderMedia ARM-based
> Systems-on-Chip integrated Rhine III adapters. Note that these
> are always in MMIO mode, and don't have any known EEPROM.
>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

For the binding:

Acked-by: Rob Herring <robh@kernel.org>
