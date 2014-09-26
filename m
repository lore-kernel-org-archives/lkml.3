Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaIZRaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 13:30:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:54891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbaIZRaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:30:06 -0400
Message-ID: <5425A296.3090900@infradead.org>
Date: Fri, 26 Sep 2014 10:29:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: akpm@linux-foundation.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        sfr@canb.auug.org.au, mhocko@suse.cz,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: mmotm 2014-09-25-16-28 uploaded (media/platform/vivid)
References: <5424a53b.o+nym6SX0Tg7EdW6%akpm@linux-foundation.org>
In-Reply-To: <5424a53b.o+nym6SX0Tg7EdW6%akpm@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/14 16:28, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-09-25-16-28 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.


on i386, when CONFIG_FB is not enabled:


ERROR: "cfb_fillrect" [drivers/media/platform/vivid/vivid.ko] undefined!
ERROR: "cfb_imageblit" [drivers/media/platform/vivid/vivid.ko] undefined!
ERROR: "fb_alloc_cmap" [drivers/media/platform/vivid/vivid.ko] undefined!
ERROR: "register_framebuffer" [drivers/media/platform/vivid/vivid.ko] undefined!
ERROR: "fb_dealloc_cmap" [drivers/media/platform/vivid/vivid.ko] undefined!
ERROR: "cfb_copyarea" [drivers/media/platform/vivid/vivid.ko] undefined!
ERROR: "unregister_framebuffer" [drivers/media/platform/vivid/vivid.ko] undefined!


I guess that VIDEO_VIVID should depend on FB.

-- 
~Randy
