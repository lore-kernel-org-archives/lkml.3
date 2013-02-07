Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab3BGFpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 00:45:43 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62014 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3BGFpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 00:45:40 -0500
Date: Wed, 6 Feb 2013 21:45:25 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Freddy Xin <freddy@asix.com.tw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
Message-ID: <20130206214525.5c5775fe@nehalam.linuxnetplumber.net>
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

> +struct {unsigned char ctrl, timer_l, timer_h, size, ifg; }
> +AX88179_BULKIN_SIZE[] =	{
> +	{7, 0x4f, 0,	0x12, 0xff},
> +	{7, 0xf0, 1,	0x15, 0xff},
> +	{7, 0xae, 7,	0x18, 0xff},
> +	{7, 0xcc, 0x4c, 0x18, 8},
> +};

Better to make it static, const, and add a couple
of line breaks.

static const struct {
      unsigned char ctrl, timer_l, timer_h, size, ifg;
} AX88179_BULKIN_SIZE[] =	{
	{7, 0x4f, 0,	0x12, 0xff},
	{7, 0xf0, 1,	0x15, 0xff},
	{7, 0xae, 7,	0x18, 0xff},
	{7, 0xcc, 0x4c, 0x18, 8},
};
