Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3JJAvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 20:51:16 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50037 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3JJAvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 20:51:15 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
References: <1348663684-1377-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 9 Oct 2013 17:51:14 -0700
Message-ID: <CAOesGMjQ=RfKVxpBAfFAanb5bXuwgNtL+fwDaJGNVXQgyTneKw@mail.gmail.com>
Subject: Re: [REPOST/PATCH] mfd: tps65910: remove warning during dt node parsing
From: Olof Johansson <olof@lixom.net>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 26, 2012 at 5:48 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Driver throw the warning message if dt node does not
> have the info for VMBCH-Threshold and VMBCH2-Threshold.
> These properties are optional property and hence it
> is not mandatory to have these on DT node and in this case
> it should not throw the warning message.
> It creates noise from driver as follows:
> [    0.384605] tps65910 4-002d: VMBCH-Threshold not specified
> [    0.384616] tps65910 4-002d: VMBCH2-Threshold not specified
>
> Removing the warning message from driver.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> It seems orginal patch has been lost. Reposting it.

I still see this with 3.12-rc. Sam?
