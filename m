Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3KHOUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:20:11 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:65513 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3KHOUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:20:09 -0500
MIME-Version: 1.0
In-Reply-To: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
Date: Fri, 8 Nov 2013 08:20:07 -0600
Message-ID: <CAMP44s1ADLHagfPa8kmx_wSyqvLf7pcN_UuOqoPShYx2HPUQXA@mail.gmail.com>
Subject: Re: [PATCH 00/16] wl1251 patches from linux-n900 tree
From: Felipe Contreras <felipe.contreras@gmail.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        freemangordon@abv.bg, aaro.koskinen@iki.fi,
        Pavel Machek <pavel@ucw.cz>, sre@ring0.de, joni.lapilainen@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 3:33 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> Hello, I'm sending wl1251 patches from linux-n900 tree [1] for comments. More
> patches come from David's monitor & packet injection work. Patches are tested
> with 3.12 rc5 kernel on Nokia N900.
>
> [1] - https://gitorious.org/linux-n900/linux-n900

How did you test these patches? I get a panic loop immediately after I
bring the interface loop in monitor mode (v3.12).

-- 
Felipe Contreras
