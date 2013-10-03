Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3JCSjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:39:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab3JCSi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:38:59 -0400
Date: Thu, 3 Oct 2013 11:39:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 00/16] 3.4.65-stable review
Message-ID: <20131003183916.GA22508@kroah.com>
References: <20131003040445.523176877@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003040445.523176877@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 09:05:24PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat Oct  5 04:04:34 UTC 2013.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.65-rc1.gz
> and the diffstat can be found below.

Due to reported build issues with -rc1, I've dropped the offending patch
and released -rc2:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.65-rc2.gz

thanks,

greg k-h
