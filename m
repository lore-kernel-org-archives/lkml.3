Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3BDEqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:46:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19737 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3BDEqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:46:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 03 Feb 2013 20:43:57 -0800
Subject: Re: CPU hotplug hang due to "swap: make each swap partition have
 one address_space"
From: Joseph Lo <josephl@nvidia.com>
To: Shaohua Li <shli@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>
In-Reply-To: <20130204023646.GA321@kernel.org>
References: <510C9DE9.9040207@wwwdotorg.org>
	 <20130204023646.GA321@kernel.org>
Date: Mon, 4 Feb 2013 12:45:44 +0800
Message-ID: <1359953144.5542.2.camel@jlo-ubuntu-64.nvidia.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-04 at 10:36 +0800, Shaohua Li wrote:
> On Fri, Feb 01, 2013 at 10:02:33PM -0700, Stephen Warren wrote:
> > Shaohua,
> > 
> > In next-20130128, commit 174f064 "swap: make each swap partition have
> > one address_space" (from the mm/akpm tree) appears causes a hang/RCU
> > stall for me when hot-unplugging a CPU.
> 
> does this one work for you?
> http://marc.info/?l=linux-mm&m=135929599505624&w=2
> Or try a more recent linux-next. The patch is in akpm's tree.
> 
Hi Shaohua,

The patch you pointed out did fix the issue. Just verified on Tegra
device.

Thanks,
Joseph


