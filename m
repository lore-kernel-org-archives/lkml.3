Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3KYVZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:25:37 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:40687 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3KYVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:25:34 -0500
MIME-Version: 1.0
In-Reply-To: <1385414073-24074-1-git-send-email-olof@lixom.net>
References: <1385414073-24074-1-git-send-email-olof@lixom.net>
Date: Mon, 25 Nov 2013 13:25:33 -0800
X-Google-Sender-Auth: ertGRMUScIX81Ky6iO_5MVmllzg
Message-ID: <CANLzEktNwOpZPS82rxSWge=+WJpyte8sGo5GYi0dVGtZdaYnKw@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: Make i2c_adapter_names static
From: Benson Leung <bleung@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 1:14 PM, Olof Johansson <olof@lixom.net> wrote:
> Not used outside of the file, so declaration should be static. Picked up by
> sparse:
>
> drivers/platform/chrome/chromeos_laptop.c:44:12: warning: symbol
>     'i2c_adapter_names' was not declared. Should it be static?
>
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Benson Leung <bleung@chromium.org>

Reviewed-by: Benson Leung <bleung@chromium.org>

Thanks,

-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
