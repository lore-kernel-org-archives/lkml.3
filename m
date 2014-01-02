Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaABSKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:10:39 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaABSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:10:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/7] tty: serial: Limit msm_serial_hs driver to platforms that use it
Date: Thu, 2 Jan 2014 19:10:22 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, arm@kernel.org,
        linux-arm-msm@vger.kernel.org, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org> <1388438133-431-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1388438133-431-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401021910.22651.arnd@arndb.de>
X-Provags-ID: V02:K0:GOzi8ShB8L0d2CDmnSLLnaROn42ybHsxwqVe/f1Fvgd
 MYHuL8a7CT4xwZt+lzly5bfjTdrv7dkFDpq0AQI1M6/da7Bk5I
 fjiOzeuK+6/mulPpdjbsvDVYm/TvDhQVZ4itEn2iF1KNIjGdhQ
 sSbWfLnYVoVJQht1oP4G3wRQ4V3zONqRPxPq+9EegUEQfq78o7
 /j/5Dx7AMu9IqR2FYjAWgmLMAZoBX3u3hIxX4LGtqgA/JK5lJt
 hhO03LFooam4acTfQJZFyilTpSwXtQCjc2apvBeJBj7NBAWQaQ
 onSeAKQLCSpO2hPaDktyryin9hDHEMEMZFQds1dqWFTqT1REyj
 jJ3W0IDHz/JKzMqhZtgA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 December 2013, Stephen Boyd wrote:
> The msm_serial_hs driver uses mach specific dma APIs. This is not
> compatible with the multi-platform ARM effort. Let's only compile
> this driver on MSM devices that are prepared to support it;
> allowing the DT based MSM devices to enter the multi-platform ARM
> build.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Do you have a plan to deal with this in the future? Aren't you going
to need it in the future on modern SoCs?

	Arnd
