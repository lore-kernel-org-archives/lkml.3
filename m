Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbaGRBUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:20:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37345 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaGRBUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:20:33 -0400
Date: Thu, 17 Jul 2014 18:20:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Hans-Christian Koch <hc.koch@scheerkoch.de>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [ PATCH V9 0/2] serial/uart/8250: Introduce tunable RX trigger
 I/F
Message-ID: <20140718012032.GA29919@kroah.com>
References: <20140716011931.31474.68825.stgit@yuno-kbuild.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716011931.31474.68825.stgit@yuno-kbuild.novalocal>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 01:19:31AM +0000, Yoshihiro YUNOMAE wrote:
> Hi Greg,
> 
> This patch set introduces tunable RX interrupt trigger I/F for 8250 serials.
> I used Greg's patch(*1) as 1st patch in this version, and applied 2nd patch
> of previous version.
> 
> Would you review this patch set?

Looks good.

> Note:
> I cleaned up Greg's patch as follows:
>  - Delete extra line break
>  - Use kcalloc instead of kmalloc
>  - sizeof(struct attribute_group *) => sizeof(**uport->tty_groups)

thanks, for doing that, nice job :)

greg k-h
