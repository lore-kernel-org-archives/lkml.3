Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3J1WGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 18:06:09 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:55244 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3J1WGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 18:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <1381921178-28511-1-git-send-email-rric@kernel.org>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
Date: Mon, 28 Oct 2013 17:06:07 -0500
Message-ID: <CAL_JsqJXg=76rnTe6rcaQsvycNZOc7hDdP3jpVPYbjzwbssDfg@mail.gmail.com>
Subject: Re: [PATCH 0/5] edac, highbank: Add Calxeda ECX-2000 support
From: Rob Herring <robherring2@gmail.com>
To: Robert Richter <rric@kernel.org>
Cc: linux-edac@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 5:59 AM, Robert Richter <rric@kernel.org> wrote:
> This patch series enables ECC edac support for Calxeda ECX-2000
> (Midway). The ECX-2000 memory controller is similar to Highbank but
> has different register bases for error and interrupt registers.
>
> Testing the driver uncovered a bug in the interrupt initialization.
> So there is also a fix for this for all the Highbank edac drivers. The
> interrupt was enabled too early which caused a crash if there are
> interrupts pending (ECC errors) during driver initialization.
>
> Also some improvements and unification of edac log messages I found
> useful.
>
> -Robert
>
>
> Rob Herring (1):
>   ARM: dts: calxeda: move memory-controller node out of ecx-common.dtsi
>
> Robert Richter (4):
>   edac, highbank: Fix interrupt setup of mem and l2 controller
>   edac, highbank: Add Calxeda ECX-2000 support
>   edac, highbank: Improve and unify naming
>   edac: Unify reporting of device info for device, mc and pci

For the series:

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob
