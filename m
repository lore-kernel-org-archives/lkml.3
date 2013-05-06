Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3EFVkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:40:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48028 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631Ab3EFVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:40:14 -0400
Message-ID: <5188212D.3030904@wwwdotorg.org>
Date: Mon, 06 May 2013 15:31:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: tony@atomide.com, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH 1/3] arm: dts: introduce config HAS_BANDGAP
References: <1367874058-2378-1-git-send-email-eduardo.valentin@ti.com> <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1367874058-2378-2-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 03:00 PM, Eduardo Valentin wrote:
> Introduce HAS_BANDGAP config entry. This config is a
> boolean value so that arch code can flag is they
> feature a bandgap device.

What does this patch have to do with device tree (there's "dts" in the
subject)? What's a BANDGAP device?
