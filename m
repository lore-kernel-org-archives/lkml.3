Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbbAGU36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:29:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbbAGU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:29:57 -0500
Date: Wed, 7 Jan 2015 21:29:56 +0100
From: Michal Marek <mmarek@suse.cz>
To: Olof Johansson <olof@lixom.net>
Cc: yann.morin.1998@free.fr, linux-kbuild@vger.kernel.org,
        dvhart@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] merge_config.sh: add -? for help
Message-ID: <20150107202956.GB21171@sepie.suse.cz>
References: <1418331304-4821-1-git-send-email-olof@lixom.net>
 <1418331304-4821-2-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418331304-4821-2-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 12:55:04PM -0800, Olof Johansson wrote:
> It's usual enough for help text that it makes sense to support it.

It's quite unusual for a *nix utility to recognize '-?'. And -h is
already supported.

Michal
