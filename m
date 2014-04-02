Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161034AbaDBXUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:20:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48487 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030669AbaDBXUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:20:34 -0400
Message-ID: <533C9B3E.3070402@gmail.com>
Date: Thu, 03 Apr 2014 01:20:30 +0200
From: Sherif <silentquote@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed coding style
References: <1396477016-30951-1-git-send-email-shehabaldin.sherif@gmail.com> <20140402222851.GA31598@kroah.com>
In-Reply-To: <20140402222851.GA31598@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resubmitted a new patch with only one style rule fixed. the rest will 
follow.

On 04/03/2014 12:28 AM, Greg KH wrote:
> On Thu, Apr 03, 2014 at 12:16:56AM +0200, Sherif Shehab Aldin wrote:
>> Fixed coding style for hfa384x_usb.c
>
> You do a lot of different types of cleanup in this patch, you are going
> to have to be more specific.
>
> Also, only do 1 thing per patch, I see whitespace cleanups, typedef
> removal and other things here.  Please break it up into a series of
> patches, each doing one thing.
>
> thanks,
>
> greg k-h
>
