Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaIBGuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaIBGuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:50:18 -0400
Message-ID: <540568A3.4010106@redhat.com>
Date: Tue, 02 Sep 2014 08:50:11 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Chunwei Chen <tuxoko@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [uas/3.16.1] panic in uas_data_cmplt()
References: <54054509.2070609@gmail.com>
In-Reply-To: <54054509.2070609@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/02/2014 06:18 AM, Chunwei Chen wrote:
> Dear all:
> 
> The kernel version is 3.16.1-1-ARCH
> 
> Today I keep getting this panic when booting up.
> http://i.imgur.com/0Rx93Kr.jpg
> 
> It might be that the UAS device was in some strange state,
> because that after I unplugged and power-cycled the UAS,
> everything went normal again.
> 
> Does anyone know what's the root cause of this issue?
> Or could anyone provide some instruction on how to debug this issue?

There seem to be some issues in the error handling paths of the uas
driver. I plan to rewrite them completely for robustness and go
through them with a fine comb to fix any possible bugs while at it.

I'll send out a mail when I've a new version ready for testing.

Regards,

Hans
