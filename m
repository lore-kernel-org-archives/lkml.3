Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbaGaLrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:47:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60429 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaGaLro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:47:44 -0400
Message-ID: <53DA2CBB.7070200@gmail.com>
Date: Thu, 31 Jul 2014 08:47:07 -0300
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: sync.c: fix missing blank line after
 declaration
References: <1406588626-6882-1-git-send-email-mopsfelder@gmail.com> <20140731001758.GB31573@kroah.com>
In-Reply-To: <20140731001758.GB31573@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 09:17 PM, Greg KH wrote:
> Also doesn't apply, are you sure you are using the staging-next branch
> of staging.git on git.kernel.org?

I was using linux-next, not staging-next.  sync.c has no checkpatch.pl 
warnings in staging-next.

Sorry for the false alarm, guys.

-- 
Murilo
