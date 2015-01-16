Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbbAPB4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:56:16 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:41549 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbbAPB4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:56:14 -0500
Date: Thu, 15 Jan 2015 17:56:02 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Stephen Wang <wstephen@codeaurora.org>
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Message-ID: <20150115175602.0709cb45@urahara>
In-Reply-To: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
References: <y>
	<1420754626-30121-1-git-send-email-wstephen@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Jan 2015 14:03:46 -0800
Stephen Wang <wstephen@codeaurora.org> wrote:

> +	uint32_t rx_bytes;		/**< Number of RX bytes */
> +	uint32_t rx_packets;		/**< Number of RX packets */

32 bit packet stats are a problem with lots of traffic.
