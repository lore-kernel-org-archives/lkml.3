Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaFBWvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:51:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbaFBWvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:51:39 -0400
Date: Mon, 2 Jun 2014 15:55:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [GIT PULL] extcon next-v2 for v3.16
Message-ID: <20140602225517.GB7641@kroah.com>
References: <538C06FC.4000009@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C06FC.4000009@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:09:16PM +0900, Chanwoo Choi wrote:
> Dear Greg,
> 
> This is extcon-next-v2 full request for v3.16. This pull request includes
> additional patchset after merged previous extcon-next pull request(tags/extcon-next-for-v3.16).
> I add detailed description of this pull request on below. Please pull extcon with following update.
> 
> Best Regards,
> Chanwoo Choi
> 
> The following changes since commit 3f79a3fb5f41e8f2229e5bf8aa725eaa79686f14:
> 
>   extcon: palmas: Use devm_extcon_dev_allocate for extcon_dev (2014-04-29 09:52:12 +0900)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/chanwoo/extcon.git tags/extcon-next-v2-for-3.16

I was thinking it was too late for 3.16-rc1, as the merge window is now
open and I like to have things in my tree a week or so before that
happens, but I figured this was nice and self-contained so I would take
it.

So I pulled, and built, and then got this:

ERROR: "regmap_irq_get_virq" [drivers/extcon/extcon-sm5502.ko] undefined!
ERROR: "regmap_add_irq_chip" [drivers/extcon/extcon-sm5502.ko] undefined!
ERROR: "regmap_del_irq_chip" [drivers/extcon/extcon-sm5502.ko] undefined!

which makes me know that you haven't done much build testing of the code
:(

So I can't take this now, sorry, please fix it up and make it ready for
3.17.  If you have bugfixes for 3.16, feel free to send them in a
separate pull request...

thanks,

greg k-h
