Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3BGFqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 00:46:21 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:64459 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3BGFqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 00:46:17 -0500
Date: Wed, 6 Feb 2013 21:46:03 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Freddy Xin <freddy@asix.com.tw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
Message-ID: <20130206214603.72524632@nehalam.linuxnetplumber.net>
In-Reply-To: <1360211794-4737-1-git-send-email-freddy@asix.com.tw>
References: <1360211794-4737-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Feb 2013 12:36:34 +0800
Freddy Xin <freddy@asix.com.tw> wrote:

> +static struct ethtool_ops ax88179_ethtool_ops = {
> +	.get_link		= ethtool_op_get_link,
> +	.get_msglevel		= usbnet_get_msglevel,
> +	.set_msglevel		= usbnet_set_msglevel,
> +	.get_wol		= ax88179_get_wol,
> +	.set_wol		= ax88179_set_wol,
> +	.get_eeprom_len		= ax88179_get_eeprom_len,
> +	.get_eeprom		= ax88179_get_eeprom,
> +	.get_settings		= ax88179_get_settings,
> +	.set_settings		= ax88179_set_settings,
> +	.nway_reset		= usbnet_nway_reset,
> +};
> +

ethtool_ops should always be const
