Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab3LCUVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 15:21:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58760 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab3LCUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 15:21:21 -0500
Message-ID: <529E3D3B.6030801@wwwdotorg.org>
Date: Tue, 03 Dec 2013 13:21:15 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCHv4] ARM: tegra: add gpiod_lookup table for paz00
References: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com> <1386074998-17833-1-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1386074998-17833-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 05:49 AM, Heikki Krogerus wrote:
> This makes it possible to request the gpio descriptors in
> rfkill_gpio driver regardless of the platform.

Acked-by: Stephen Warren <swarren@nvidia.com>

(I haven't retested V4. The previous versions worked fine...)
