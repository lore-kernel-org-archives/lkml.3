Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaAFLjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:39:09 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:58159 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899AbaAFLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:39:08 -0500
Message-ID: <1389008346.2249.11.camel@linaro1.home>
Subject: Re: Latest Linux version known to be working with Fast Model
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Mj Embd <mj.embd@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Date: Mon, 06 Jan 2014 11:39:06 +0000
In-Reply-To: <CAPUj1OPs1z9y_j=kLUA7N8Xnnuuj_5_PZaPDaUsJNW-waQkvug@mail.gmail.com>
References: <CAPUj1OPs1z9y_j=kLUA7N8Xnnuuj_5_PZaPDaUsJNW-waQkvug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 10:48 +0530, Mj Embd wrote:
> Hi all,
> 
> Can anyone help on this...
> Looking for latest linux version working with FastModel (A15x2 or A15x2_A7x2)
> along with device tree and config file.

The latest kernel is Linus Torvalds' master branch and the config is
arch/arm/configs/vexpress_defconfig in this. For the device-trees look
at http://linux-arm.org/git?p=arm-dts.git, e.g. the file
fast_models/rtsm_ve-cortex_a15x2.dts

-- 
Tixy

