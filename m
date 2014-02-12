Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaBLMez (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:34:55 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43855 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbaBLMew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:34:52 -0500
Date: Wed, 12 Feb 2014 13:34:49 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, b.brezillon@overkiz.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/8] Device Tree support for the at91sam9261ek
Message-ID: <20140212133449.5c42216d@skate>
In-Reply-To: <52FB5795.9020708@free-electrons.com>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
	<52FB5795.9020708@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Wed, 12 Feb 2014 12:14:29 +0100, Gregory CLEMENT wrote:

> For dm9000 the issue is (again) related to an ordering problem:
> the Ethernet need an interrupt provided by the gpio driver. Unfortunately,
> the gpio driver initialization is called after the dm900 driver
> initialization.

And -EPROBE_DEFER doesn't solve this problem?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
