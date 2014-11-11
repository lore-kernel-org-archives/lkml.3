Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaKKHRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 02:17:08 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:45567 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaKKHRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 02:17:07 -0500
Message-ID: <5461B7EF.2090308@ape3000.com>
Date: Tue, 11 Nov 2014 09:17:03 +0200
From: Lauri Niskanen <ape@ape3000.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: misc: Add driver for ALVA Nanoface
References: <1415689506-1755-1-git-send-email-ape@ape3000.com> <20141111070759.GA16276@kroah.com>
In-Reply-To: <20141111070759.GA16276@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 09:07, Greg Kroah-Hartman wrote:
> Any reason this can't be a simple userspace program that writes the
> needed command to the device using libusb instead of being a kernel
> driver?  This seems like overkill for a kernel driver to me.

You are probably right. It indeed should be possible to do this in 
userspace. I thought that having a kernel driver would still be 
benefical since it adds plug-and-play availability for all Linux users 
without having to deal with userspace driver programs.

You are far more experienced with these things than me, so I am happy to 
let you make the decision about whether to have a kernel driver or not.

-- 
Lauri Niskanen
