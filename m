Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaJAIPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:15:23 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58326 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJAIPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:15:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 15/15] misc: at25: Add ACPI probing support
Date: Wed, 01 Oct 2014 10:15:10 +0200
Message-ID: <1988496.7SQY397j9e@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2551386.HUYYQnE3a6@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <2551386.HUYYQnE3a6@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:e1r47v7UAO6vDK5k0VbhdrNnDpyISHgH8p8U82D8Iab
 SGW+Gn4viq/y3dFrghTWFbMfWYQS5nX0U0qa79/W9mKxtDk8kU
 JHtKjEvdbnTvQm2tCQr9K1CGrt/jvpKBuRgQte7zMF8STiJomq
 PcVo+HXog2hHn7SE/w4RZ+FUwZNuXHWCapdp0Gp+igTkYv8/Zm
 CDoVGHopdvbFJryjoSmOuRHCJMhkVc9xUu0boCOGP4MBrdx54Y
 G+lht+yjB2QjkR8aD9KCVPG55RmvOcLeq4f1IE4J7nn0Dfei4O
 PVTekm8Haoarjh4Jsp8RHxlZEGc24I74zAZbtqxBCh29yv8rca
 +v/qx9+hRRX8Hyrm+/ZQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:22:27 Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Add support for matching using DT compatible string from ACPI _DSD.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

Same comment applies as in patch 13.

	Arnd
