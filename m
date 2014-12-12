Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031101AbaLLSS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:18:58 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46521 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935132AbaLLSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:18:56 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:7c93:3f22:993c:1f7b]
In-Reply-To: <54895821.3050902@intel.com>
References: <54868CF6.6020505@intel.com>
	<CAOesGMirF-_H2ZzFR-VpwkEErZE2uQJSYx5EuePArQsEh=r_Kw@mail.gmail.com>
	<20141211010226.GA26253@aaronlu.sh.intel.com>
	<CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com>
	<1418265472.12435.68.camel@rzhang1-toshiba>
	<548934D0.8000502@intel.com>
	<1418286781.12435.73.camel@rzhang1-toshiba>
	<54895821.3050902@intel.com>
Date: Fri, 12 Dec 2014 10:18:55 -0800
Message-ID: <CAOesGMjKdi6wPsy+U1makbFyJpsj8RZykOZ5BEYrFWj_VzUxqA@mail.gmail.com>
Subject: Re: [PATCH v6] Thermal: introduce INT3406 thermal driver
From: Olof Johansson <olof@lixom.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



On Thu, Dec 11, 2014 at 12:38 AM, Aaron Lu <aaron.lu@intel.com> wrote:
> INT3406 ACPI device object resembles an ACPI video output device, but its
> _BCM is said to be deprecated and should not be used. So we will make
> use of the raw interface to do the actual cooling. Due to this, the
> backlight core has some modifications. Also, to re-use some of the ACPI
> video module's code, one function has been exported.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
> v6: Fix an issue that wrongly set error path return value as reported
> by Olof Johansson.

Last night's -next was still broken. I take it this wasn't applied
yet? Please at least revert the original patch.


-Olof
