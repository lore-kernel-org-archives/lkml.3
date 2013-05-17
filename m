Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3EQNGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3EQNGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:06:22 -0400
Date: Fri, 17 May 2013 09:06:14 -0400
From: Don Zickus <dzickus@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] watchdog: Disallow setting watchdog_thresh to -1
Message-ID: <20130517130614.GF78758@redhat.com>
References: <51959668.9040106@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51959668.9040106@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:31:04AM +0800, Li Zefan wrote:
> In old kernels, it's allowed to set softlockup_thresh to -1 or 0
> to disable softlockup detection. However watchdog_thresh only
> uses 0 to disable detection, and setting it to -1 just froze my
> box and nothing I can do but reboot.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Don Zickus <dzickus@redhat.com>
