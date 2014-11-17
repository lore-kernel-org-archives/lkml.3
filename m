Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKQQxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:53:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaKQQxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:53:52 -0500
Date: Mon, 17 Nov 2014 17:53:48 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Oded Gabbay <oded.gabbay@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141117165348.GA19712@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
 <20141027151327.GE9734@suse.de>
 <544E61A1.7090400@amd.com>
 <20141027083552.4af5753f@jbarnes-hsw>
 <5450B472.1020301@amd.com>
 <20141105120351.GH8354@suse.de>
 <20141105135109.39ea54fe@jbarnes-hsw>
 <20141106130122.GJ8354@suse.de>
 <20141112140741.0ebef398@jbarnes-hsw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112140741.0ebef398@jbarnes-hsw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:07:41PM -0800, Jesse Barnes wrote:
> I wonder if we need a new "device_task_struct" or
> "coprocessor_task_struct" or something to wrap some simple stuff on
> non-CPU devices.  They could be sub-classed by drivers that needed
> additional driver specific data.

Yes, I think something like a device_task_struct may be needed at some
point. It could be used in some generic code for task scheduling and
management on the devices too.  The KFD driver already implements a
scheduler and stuff, maybe some of this code can be generalized to be
useable by other drivers and a common userspace interface (at least to
some degree).


	Joerg

