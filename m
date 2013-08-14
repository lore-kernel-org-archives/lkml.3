Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab3HNSQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:16:08 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47206 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab3HNSQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <520A3467.20203@nvidia.com>
References: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com>
	<1375794755-6246-4-git-send-email-ldewangan@nvidia.com>
	<5201467D.9020803@wwwdotorg.org>
	<520A3467.20203@nvidia.com>
Date: Wed, 14 Aug 2013 20:16:05 +0200
Message-ID: <CACRpkda7+jHoCJyx0LUvk8omzV-K54JHCq1j199Jw1YnTk69Ww@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] pinctrl: palmas: add pincontrol driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 3:28 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Can you please review this series?

It is a fine driver, so applied it.

> I have some follow on patches on cleanups of tegra pincontrol driver to use
> the utils function which is introduced on this series which I want to send.

Hit me with all you have.

Yours,
Linus Walleij
