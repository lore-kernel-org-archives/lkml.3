Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbbANO4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:56:40 -0500
Received: from foo.stuge.se ([212.116.89.98]:51804 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbbANO4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:56:39 -0500
Message-ID: <20150114145636.9430.qmail@stuge.se>
Date: Wed, 14 Jan 2015 15:56:36 +0100
From: Peter Stuge <peter@stuge.se>
To: Mark Glover <mark@actisense.com>
Cc: johan@kernel.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added PIDs for Actisense USB Devices
Mail-Followup-To: Mark Glover <mark@actisense.com>, johan@kernel.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1421243920-15048-1-git-send-email-mark@actisense.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421243920-15048-1-git-send-email-mark@actisense.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Glover wrote:
> From: Mark Glover <mark@actisense.com>
> 
>  Signed-off-by: Mark Glover <mark@actisense.com>

There's an extraneous leading whitespace on the Signed-off-by line.


> +#define CHETCO_SEASWITCH_PID		0xA549 /* SeaSwitch USB Apadter */

The typo remains. "Apadter" here --------------------------------^


//Peter
