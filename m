Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaGIUw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:52:26 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:51156 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaGIUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:52:24 -0400
Date: Wed, 9 Jul 2014 22:52:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/4] Documentation: use subdir-y to avoid unnecessary
 built-in.o files
Message-ID: <20140709205219.GC32335@ravnborg.org>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
 <53AF78A7.8050106@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AF78A7.8050106@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 07:23:35PM -0700, Randy Dunlap wrote:
> On 04/17/14 07:11, Peter Foley wrote:
> > Change the Documentation makefiles from obj-m to subdir-y
> > to avoid generating unnecessary built-in.o files since nothing
> > in Documentation/ is ever linked in to vmlinux.
> > 
> > Signed-off-by: Peter Foley <pefoley2@pefoley.com>
> 
> Hi Michal,
> 
> Does this look good to you?
> I don't have enough makefile fu (or is it foo?) to judge this.
Looks OK.
Please add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
