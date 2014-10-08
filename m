Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaJHTap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 15:30:45 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:51564 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbaJHTan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 15:30:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v2 0/7] ARM: meson: add support for Meson8
Date: Wed, 08 Oct 2014 21:30:09 +0200
Message-ID: <59241134.gsbhNQV8Wa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412546359-15062-1-git-send-email-b.galvani@gmail.com>
References: <1412546359-15062-1-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ewQFHNer0NuPWATSf2B2ZL4IINW1FQqLuCZ7wT0OQye
 Vp/YjCDvGFpvCEsJkJYiNt56LWUdO0JYZ91WkvC1tvYxrtW8I5
 HOGbbf+boyO/raq8b/K5MLk0UKFc6Aybq+yBLAH2iX4c2hPsr9
 mNGX0D7Es2JlXyAFu8yZguJTKBtmcr3M5zIbT5D0mh+xrKzTH7
 ACJ3aLLcGGJ9r4oLNpHqvbW8fIgXq62XA5cOEenn42yZV50UNr
 n4mQ858oNtYHAfsfIlOotl+xTjghwqAEWjMtSmRVR8WbjbAbkH
 xixgKgSBWIefWq90aA7GVvgi5KMRUNAZwEi8P3d1mVQ/V19LTl
 6NRvGRjBBZkeX6o5HWFE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2014 23:59:12 Beniamino Galvani wrote:
> 
> this patchset introduces support for Amlogic Meson8, which is a family
> of quad-core Cortex-A9 SoCs used in tablets and set-top boxes.
> 
> Changes since v1:
>  - reused the existing DT machine definition and renamed it to be more
>    generic
>  - added L2 cache support

Looks all good to me

Acked-by: Arnd Bergmann <arnd@arndb.de>
