Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3EaPMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:12:36 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:43102 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3EaPM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:12:27 -0400
MIME-Version: 1.0
In-Reply-To: <1368629928-6723-2-git-send-email-eduardo.valentin@ti.com>
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com>
	<1368629928-6723-2-git-send-email-eduardo.valentin@ti.com>
Date: Fri, 31 May 2013 12:12:26 -0300
Message-ID: <CAOMZO5CL=apxbkCHA6Xsw+m5d-rhe_VcOaA9KpkSmiJ=ZRL7gA@mail.gmail.com>
Subject: Re: [PATCHv2 1/3] arm: introduce config HAS_BANDGAP
From: Fabio Estevam <festevam@gmail.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: tony@atomide.com, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:58 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Introduce HAS_BANDGAP config entry. This config is a
> boolean value so that arch code can flag is they
> feature a bandgap device.
>
> This config entry follows the same idea behind
> ARCH_HAS_CPUFREQ.

It would be nice if you explain what BANDGAP means here, since you
introduce this option in this patch.
