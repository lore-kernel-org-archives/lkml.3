Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3A1KLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 05:11:53 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:44237 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3A1KLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 05:11:50 -0500
MIME-Version: 1.0
In-Reply-To: <20130125164800.GB1174@sortiz-mobl>
References: <b9fec05c-d383-4282-b2af-c95855ff6abb@zimbra>
	<3ffa5032-0565-48f0-a4ae-473452f4c902@zimbra>
	<CACRpkdZHndQsDZpn7BCFNXAO3k5vREYxDJkcYQ3_3sTbKAQLLA@mail.gmail.com>
	<20130125164800.GB1174@sortiz-mobl>
Date: Mon, 28 Jan 2013 11:11:49 +0100
Message-ID: <CACRpkdYV3KGz45Ko1n-QJ6VQ4Y8SAb3zd87AvfpP1TSUAh=FsQ@mail.gmail.com>
Subject: Re: [PATCH v3] lpc_ich: fix gpio base and control offsets
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aaron Sierra <asierra@xes-inc.com>, Paul Bolle <pebolle@tiscali.nl>,
        Peter Hurley <peter@hurleysoftware.com>,
        =?ISO-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 5:48 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Fri, Jan 25, 2013 at 10:47:45AM +0100, Linus Walleij wrote:

>> So where is this id->driver_data which is just assigned to
>> priv->chipset coming from again? ACPI something?
>
> It comes from the static PCI table the driver defines itself. It allows you to
> pass meta data associated to a specific PCI ID.

OK cool, I think we can conclude that this patch is fine after the
boot tests and all:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
