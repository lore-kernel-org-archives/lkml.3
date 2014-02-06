Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaBFOHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:07:44 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:53277 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBFOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:07:42 -0500
X-Auth-Info: 9dYiwu0tVXgPk6JjXN8Z73XsYwKwoyBC7/rYFUZH75s=
From: Marek Vasut <marex@denx.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 10/12] backlight: lms283gf05: Remove unnecessary OOM messages
Date: Thu, 6 Feb 2014 14:34:22 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.11.3; x86_64; ; )
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com> <000b01cf2315$20cc9ec0$6265dc40$%han@samsung.com>
In-Reply-To: <000b01cf2315$20cc9ec0$6265dc40$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201402061434.22470.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 06, 2014 at 09:26:26 AM, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
