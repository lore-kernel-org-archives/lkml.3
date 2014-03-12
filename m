Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbaCLNrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:47:08 -0400
Received: from canardo.mork.no ([148.122.252.1]:48036 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbaCLNqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:46:40 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Hayes Wang <hayeswang@realtek.com>
Cc: <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] r8152: add CONFIG_RTL8152_EARLY_AGG_SUPER
Organization: m
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
	<1394526259-5513-2-git-send-email-hayeswang@realtek.com>
	<1394628023-12713-1-git-send-email-hayeswang@realtek.com>
Date: Wed, 12 Mar 2014 14:40:17 +0100
In-Reply-To: <1394628023-12713-1-git-send-email-hayeswang@realtek.com> (Hayes
	Wang's message of "Wed, 12 Mar 2014 20:39:58 +0800")
Message-ID: <87txb3lem6.fsf@nemi.mork.no>
User-Agent: Gnus/5.130009 (Ma Gnus v0.9) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> writes:

> +	config RTL8152_EARLY_AGG_SUPER
> +		hex "rx early agg parameter for super speed"
> +		default 0x0e832981
> +		help
> +		  This is the rx early agg parameter for USB super speed.
> +
> +	endmenu

How do I as an end user know how to adjust this magic(?) value?  Having
a config setting like this without further documentation seems
completely pointless. Anyone with enough knowledge about the driver and
devices will be perfectly capable of editing the driver source anyway.



Bjørn
