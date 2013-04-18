Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3DRNAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:00:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab3DRNAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:00:06 -0400
Message-ID: <516FEE55.6070001@suse.cz>
Date: Thu, 18 Apr 2013 15:00:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] rpm-pkg: Do not package the whole source directory
References: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1366058108-3500-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.4.2013 22:35, Michal Marek wrote:
> The source tree can contain lots of uninteresting data like tag or
> cscope files, packaging which slows down make rpm needlessly. It can
> also break the build, if the tree contains an unrelated file named
> *.spec. The downside of this change is that new subdirectories have to
> be added to the KBUILD_ALLDIR variable in the top-level Makefile. The
> upside is that the behavior is more predictable.

I merged this and the other three patches to kbuild.git#misc.

Michal
