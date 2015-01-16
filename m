Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbbAPB6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:58:43 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48532 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbAPB6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:58:41 -0500
Date: Thu, 15 Jan 2015 17:58:30 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Stephen Wang <wstephen@codeaurora.org>
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Message-ID: <20150115175830.5210cfb8@urahara>
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

> +	struct nss_gmac_data_plane_ops *data_plane_ops;
> +					/* ops to send messages to nss-drv    */

This should be a const pointer.
