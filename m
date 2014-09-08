Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaIHMhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:37:42 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46179 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaIHMhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:37:41 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.61.81]
In-Reply-To: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1408533593-32346-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 8 Sep 2014 14:37:39 +0200
Message-ID: <CABxcv==ycrPw1MTv7X0baX2WfqgDS+4EEfGAWc+ZhpiR6=Uy+Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Add max77802 support for Peach boards
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On Wed, Aug 20, 2014 at 1:19 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>
> This is a second version of the series that adds max77802 support for
> the Peach Pit and Pi boards. The series also have all the pending
> patches that were posted but depended on this support. I've picked
> all the patches I found and rebased them to be sure that they apply
> cleanly on top of linux-next. Also I've taken some DT snippets from
> the downstream Chrome OS 3.8 kernel DTS for devices that use one of
> these regulators as their input supply.
>

Any comments on this series?

Best regards,
Javier
