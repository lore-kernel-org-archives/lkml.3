Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaHDOKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:10:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbaHDOKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:10:22 -0400
Message-ID: <53DF944C.2090207@suse.cz>
Date: Mon, 04 Aug 2014 16:10:20 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Devin J. Pohly" <djpohly@gmail.com>
CC: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Devin J. Pohly" <djpohly+linux@gmail.com>
Subject: Re: [PATCH 1/1] kbuild: use $(srctree) to locate config headers from
 external modules
References: <1406922443-22770-1-git-send-email-djpohly+linux@gmail.com>
In-Reply-To: <1406922443-22770-1-git-send-email-djpohly+linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-01 21:47, Devin J. Pohly wrote:
> When making modules_install for an out-of-tree module, the current
> directory is $(KBUILD_OUTPUT), and the Makefile recipe which verifies
> the existence of files in include/config is unable to find them using a
> relative path.  This leads to a spurious and puzzling "Kernel
> configuration is invalid" warning when no configuration is actually
> needed.

include/generated is located in $(KBUILD_OUTPUT), which is different
from $(srctree) when using O=. Can you post a sequence of commands that
leads to the error you are seeing?

Thanks,
Michal
