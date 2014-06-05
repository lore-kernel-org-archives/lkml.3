Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaFEXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:16:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaFEXQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:16:26 -0400
Date: Thu, 5 Jun 2014 16:20:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/228] 3.14.6-stable review
Message-ID: <20140605232008.GB14136@kroah.com>
References: <20140604232347.966798903@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:20:29PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.6 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Jun  6 23:23:11 UTC 2014.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
> and the diffstat can be found below.

I've updated the stable tree with the futex patches as lots of people
have been asking me about them, so here is a -rc2 with them
incorporated:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
