Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3GOXaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:30:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59788 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab3GOXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:30:13 -0400
Message-ID: <51E48452.8010600@wwwdotorg.org>
Date: Mon, 15 Jul 2013 17:22:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
CC: balbi@ti.com, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 4/9] ARM: tegra: Remove USB platform data
References: <1373918029-28977-1-git-send-email-ttynkkynen@nvidia.com> <1373918029-28977-5-git-send-email-ttynkkynen@nvidia.com>
In-Reply-To: <1373918029-28977-5-git-send-email-ttynkkynen@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 01:53 PM, Tuomas Tynkkynen wrote:
> USB-related platform data is not used anymore in the Tegra USB drivers,
> so remove all of it.

Acked-by: Stephen Warren <swarren@nvidia.com>

(I said that for v1 too. Tuomas, you can cut/paste that ack into the
commit description to keep it for any future postings).

I think it's best to take this patch through the USB tree along with the
rest. Otherwise, we'd have to wait for 3.13 to apply it. I don't believe
this will cause any conflicts.

