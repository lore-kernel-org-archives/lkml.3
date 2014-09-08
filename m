Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaIHWW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:22:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61101 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaIHWW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:22:58 -0400
Date: Tue, 9 Sep 2014 07:22:53 +0900
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140908222253.GB3806@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1534583.H3bxpdPhXK@vostro.rjw.lan>
 <CAM_iQpW8XT_ixUTG-9JPoeZ-kqMN1YpkpwvgQtQVDNLDJ5cn8A@mail.gmail.com>
 <3827451.ToKxd7Xb2J@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3827451.ToKxd7Xb2J@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 11:53:34PM +0200, Rafael J. Wysocki wrote:
> But please tell me this: If TIF_MEMDIE is set and we thaw the process,
> can it do *anything* before dying or will it die immediately?

The task could be in freezer from anywhere and there's no limit in
what the task may do before it eventually dies.

Thanks.

-- 
tejun
