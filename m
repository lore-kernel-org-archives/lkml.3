Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab3G3GNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 02:13:31 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:57831 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab3G3GNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 02:13:30 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2013 02:13:30 EDT
Date: Tue, 30 Jul 2013 08:05:44 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Rui Xiang <rui.xiang@huawei.com>, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org,
        libo.chen@huawei.com, akpm@linux-foundation.org
Subject: Re: [PATCH 0/9] Add namespace support for syslog v2
Message-ID: <20130730080544.3aa38e11@pluto.restena.lu>
In-Reply-To: <87wqo9urao.fsf@xmission.com>
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
	<87wqo9urao.fsf@xmission.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 11:58:23 -0700 Eric W. Biederman wrote:
> Rui Xiang <rui.xiang@huawei.com> writes:
> 
> > This patchset introduces a system log namespace.
> 
> The largest outstanding question is not answered.  Can't we just fix
> iptables to log somehwere better than dmesg, and would that not entirely
> remove the need for this work?

Doesn't NFLOG target + ulogd allow for this?

Though last I tried it seems the corresponding netlink resources are not
(fully) netns aware (unless I did something wrong in my setup).

Bruno


> That question needs to be answered before we proceed down this path.
> 
> Eric
