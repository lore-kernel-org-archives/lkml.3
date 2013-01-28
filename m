Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3A1Stx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:49:53 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56565 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab3A1Stv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:49:51 -0500
Message-ID: <5106C84C.8010605@wwwdotorg.org>
Date: Mon, 28 Jan 2013 11:49:48 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: host: tegra: make use of PHY pointer of HCD
References: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1359023223-13751-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 03:27 AM, Venu Byravarasu wrote:
> As pointer to PHY structure can be stored in struct usb_hcd
> making use of it, to call Tegra PHY APIs.
> 
> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
> so that to avoid dereferencing of hcd after its freed up.

I have applied this to Tegra's for-3.9/soc-usb branch.
