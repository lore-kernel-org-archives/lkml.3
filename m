Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3FOKAf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 06:00:35 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:40904 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3FOKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 06:00:33 -0400
Date: Sat, 15 Jun 2013 12:00:14 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 15/31] mips/kvm: Exception handling to leave and reenter
 guest mode.
Message-ID: <20130615100014.GE18936@linux-mips.org>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
 <1370646215-6543-16-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370646215-6543-16-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 04:03:19PM -0700, David Daney wrote:

> Currently this is a little complex, here are the facts about how it works:

I'm not so much worried about the intrinic complexity of the job your
code is trying to do rather than stackframe.h getting every more complex.
We're reaching the point where reimplementing is using uasm.c is looking
like a good thing.  But certainly not now.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
