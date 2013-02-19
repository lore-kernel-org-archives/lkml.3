Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab3BSSmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:42:35 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:47892 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSSme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:42:34 -0500
Date: Tue, 19 Feb 2013 10:42:27 -0800
From: Tejun Heo <tj@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH linux-next v2] firewire: fw_device_init: 'minor' may be
 used uninitialized
Message-ID: <20130219184227.GS17414@htj.dyndns.org>
References: <1361222343-112898-1-git-send-email-tim.gardner@canonical.com>
 <1361222676-113069-1-git-send-email-tim.gardner@canonical.com>
 <20130219100907.5dff3124@stein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130219100907.5dff3124@stein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 10:09:07AM +0100, Stefan Richter wrote:
> Date: Mon, 18 Feb 2013 14:24:36 -0700
> From: Tim Gardner <tim.gardner@canonical.com>
> 
> 'firewire: convert to idr_alloc()' accidentally orphaned 'minor'.
> 
> drivers/firewire/core-device.c: In function ‘fw_device_init’:
> drivers/firewire/core-device.c:1029:24: warning: ‘minor’ may be used uninitialized in this function [-Wuninitialized]
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Acked-by: Tejun Heo <tj@kernel.org>

Sorry about that. :)

-- 
tejun
