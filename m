Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab3LSD1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 22:27:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3LSD1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 22:27:42 -0500
Date: Wed, 18 Dec 2013 19:27:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
Message-ID: <20131219032745.GA29603@kroah.com>
References: <20131218211219.461663463@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:10:37PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.6 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc1.gz
> and the diffstat can be found below.

Thanks to a bug on my part, there's now a -rc2 out for people to test
with:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc2.gz

Note, if you didn't have a build-failure with -rc1 then no need to test
-rc2, it's only a specific staging driver that had an issue.

thanks,

greg k-h
