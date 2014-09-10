Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaIJDai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:30:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:54853 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaIJDag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:30:36 -0400
MIME-Version: 1.0
In-Reply-To: <1410290435-16976-1-git-send-email-puthik@chromium.org>
References: <1410290435-16976-1-git-send-email-puthik@chromium.org>
Date: Wed, 10 Sep 2014 11:30:35 +0800
X-Google-Sender-Auth: Z0Pwubt8iMiXCjlg8EeJbq4OrZs
Message-ID: <CANLzEkuy7KrbAbEDYC6k2cxFfdcLa8vLju0jt3oUSCWa9VnO5A@mail.gmail.com>
Subject: Re: [PATCH] bq27x00_battery: Add support to bq27742
From: Benson Leung <bleung@chromium.org>
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: linux-pm@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Rhyland Klein <rklein@nvidia.com>, Olof Johansson <olofj@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 3:20 AM, Puthikorn Voravootivat
<puthik@chromium.org> wrote:
> Add support to bq27742 in bq27x00 driver. bq27742 register
> addresses are mostly mostly the same as bq27500 addresses
> with minor differences.
>
> Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
> Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
> Reviewed-by: Rhyland Klein <rklein@nvidia.com>

 Reviewed-by: Benson Leung <bleung@chromium.org>

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
