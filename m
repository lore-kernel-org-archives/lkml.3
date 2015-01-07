Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbbAGU2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:28:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbbAGU2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:28:51 -0500
Date: Wed, 7 Jan 2015 21:28:49 +0100
From: Michal Marek <mmarek@suse.cz>
To: Olof Johansson <olof@lixom.net>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        dvhart@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] merge_config.sh: Display usage if given too few
 arguments
Message-ID: <20150107202849.GA21171@sepie.suse.cz>
References: <1418331304-4821-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418331304-4821-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:55:03PM -0800, Olof Johansson wrote:
> Two or more arguments are always expected. Show usage and exit if
> given less.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Applied to kbuild.git#kconfig, thanks.

Michal
