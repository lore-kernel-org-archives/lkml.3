Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaKFNDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:03:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaKFNDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:03:11 -0500
Date: Thu, 6 Nov 2014 14:03:08 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141106130308.GK8354@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
 <20141027151327.GE9734@suse.de>
 <544E61A1.7090400@amd.com>
 <20141027083552.4af5753f@jbarnes-hsw>
 <5450B472.1020301@amd.com>
 <20141105120351.GH8354@suse.de>
 <20141105135109.39ea54fe@jbarnes-hsw>
 <545B3676.9030609@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B3676.9030609@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:51:02AM +0200, Oded Gabbay wrote:
> Joerg, sorry for the dumb question but what do you mean by "task
> accounting for page-faults"? Where is that code in IOMMUv2 driver
> now?

Linux counts major and minor page-faults for each running task. For the
IOMMUv2 driver this was done in the get_user_pages function, at least
until I changed the task parameter to NULL. Currently there is no
accounting for that in the IOMMUv2 driver.


	Joerg

