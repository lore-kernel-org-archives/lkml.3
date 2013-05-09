Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab3EIUZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 16:25:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41691 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab3EIUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 16:25:33 -0400
Date: Thu, 9 May 2013 13:25:34 -0700
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Simon Glass <sjg@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: exynos: dts: Fixed vbus-gpios
Message-ID: <20130509202534.GB21831@quad.lixom.net>
References: <1368034636-15865-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368034636-15865-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:37:16AM -0700, Doug Anderson wrote:
> The 'samsung,vbus-gpio' was submitted before pinmux landed for
> exynos5250 and uses the old-style gpio specifier.  Fix the two
> exynos5250 boards that use it.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>


Applied to arm-soc fixes.

Thanks,


-Olof
