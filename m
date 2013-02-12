Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab3BLQxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:53:34 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:60002 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab3BLQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:53:32 -0500
X-Sasl-enc: DiAFSX1DSdSsnhWVBH9zfKNeDcpjw/xLRZWveONh+rxa 1360688011
Message-ID: <511A7389.7090403@ladisch.de>
Date: Tue, 12 Feb 2013 17:53:29 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: kernel kernel <kernel@kenobrien.org>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Xonar DG pci sound card driver incomplete
References: <CAG=jzgDxD5ZB683bieoCHQFTehRmOMwnzgefmeSenRPFudY4RA@mail.gmail.com>
In-Reply-To: <CAG=jzgDxD5ZB683bieoCHQFTehRmOMwnzgefmeSenRPFudY4RA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel kernel wrote:
> Requesting guidance on how to implement the missing mic input support
> for this Asus Xonar card. I've downloaded the relevant datasheets but
> am unsure how to proceed.

Rip out the card, and look (or eletrically trace) how the CMI8788's
GPIOs and the CS4245's inputs/outputs are connected.

Test how to configure and set the GPIOs so that the mic works.
Also check the register configuration of the CS4245.


Regards,
Clemens
