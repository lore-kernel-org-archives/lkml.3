Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbaDXNRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:17:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaDXNR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:17:29 -0400
Message-ID: <53590EE7.9070108@suse.cz>
Date: Thu, 24 Apr 2014 15:17:27 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] scripts/tags.sh: ignore code of user space tools
References: <20140421080308.14562.30914.stgit@zurg>
In-Reply-To: <20140421080308.14562.30914.stgit@zurg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-21 10:03, Konstantin Khlebnikov wrote:
> User space code in tools/ often reuses names of kernel constructions,
> this confuses navigation in the normal kernel code. Let's fix this mess.
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>

Applied to kbuild.git#misc, thanks.

Michal

