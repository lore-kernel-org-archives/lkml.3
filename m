Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab3H1PLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:11:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab3H1PL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:11:29 -0400
Message-ID: <521E131E.6060503@suse.cz>
Date: Wed, 28 Aug 2013 17:11:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not overwrite include/config/kernel.release
 needlessly
References: <1377611624-11570-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1377611624-11570-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.8.2013 15:53, Michal Marek wrote:
> Use filechk to detect if the content changed or not.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

I merged this to kbuild.git#kbuild now.

Thanks,
Michal

