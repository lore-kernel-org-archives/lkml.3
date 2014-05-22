Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaEVHDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:03:43 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:42439 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaEVHDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:03:42 -0400
Date: Thu, 22 May 2014 11:03:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>, shawn@churchofgit.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, vdavydov@parallels.com,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140522070339.GB8946@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220642100.9695@ionos.tec.linutronix.de>
 <20140521215707.GH12819@moon>
 <alpine.DEB.2.02.1405220658530.9695@ionos.tec.linutronix.de>
 <20140521223511.GI12819@moon>
 <CAHO5Pa3NFndwZUKGdEt8AYnYLXvd4aJB1RdWOQ-Kcht+Y0WEyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa3NFndwZUKGdEt8AYnYLXvd4aJB1RdWOQ-Kcht+Y0WEyA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 08:32:45AM +0200, Michael Kerrisk wrote:
> [Thomas, thanks for pinging me on this.]
> 
> Hi Cyril
> 
> Please CC linux-api on changes that affect kernel-user-space ABI/API.

Sure!
