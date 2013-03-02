Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3CBPP5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 10:15:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:53078 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3CBPP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 10:15:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,767,1355126400"; 
   d="scan'208";a="298121946"
Message-ID: <1362237384.2745.20.camel@sauron>
Subject: Re: [PATCH] phram: Allow the user to set the erase page size.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: "Patrick O'Grady" <patrick@baymotion.com>
Cc: Joern Engel <joern@lazybastard.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:16:24 +0200
In-Reply-To: <CAJ7m5OqYv_=JB9NhHsqBsa8YU0DFRoP7C+W10PY22wonAGJK=A@mail.gmail.com>
References: <CAJ7m5OqYv_=JB9NhHsqBsa8YU0DFRoP7C+W10PY22wonAGJK=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 12:35 -0800, Patrick O'Grady wrote:
> From: Patrick O'Grady <patrick@baymotion.com>
> 
> Permit the user to specify the erase page size as a parameter.
> This solves two problems:
> 
> - phram can access images made by mkfs.jffs2.  mkfs.jffs2 won't
> create images with erase sizes less than 8KiB; many architectures
> define PAGE_SIZE as 4KiB.
> 
> - Allows more effective use of small capacity devices.  JFFS2
> needs somewhere between 2 and 5 empty pages for garbage collection;
> and for an NVRAM part with only 32KiB of space, a smaller erase page
> allows much better utilization in applications where garbage collection
> is important.

Unfortunately, the patch is line-wrapped and not applicable to the
latest kernel tree. Would you please refresh and re-send properly?

-- 
Best Regards,
Artem Bityutskiy

