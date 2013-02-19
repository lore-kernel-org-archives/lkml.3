Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab3BSAHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:07:13 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:61485 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799Ab3BSAHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:07:11 -0500
MIME-Version: 1.0
In-Reply-To: <5122BF88.1050007@gmail.com>
References: <5122BF88.1050007@gmail.com>
Date: Tue, 19 Feb 2013 01:07:07 +0100
Message-ID: <CACTFLAME+O4J2eme6Pw5_rGBuVBNLq2cX86WRvoev1W=ZDnnmg@mail.gmail.com>
Subject: Re: Question about fixed-clock
From: Daniel Mack <zonque@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 12:55 AM, Daniel Mack <zonque@gmail.com> wrote:
> Hi,
>
> This might be a stupid question, but I'm somehow stuck here. I'm using a
> driver with the following DTS sub-node:
>
>         ref25: ref25M {
>                 compatible = "fixed-clock";
>                 #clock-cells = <0>;
>                 clock-frequency = <25000000>;
>         };
>
>         clock-generator@0 {
>                                 /* ... */
>                                 #clock-cells = <1>;

Sorry - this is actually <0>.
