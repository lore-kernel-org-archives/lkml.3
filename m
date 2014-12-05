Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaLELER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:04:17 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55345 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLELEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:04:16 -0500
Date: Fri, 5 Dec 2014 03:04:12 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: "Joshua I. James" <joshua@cybercrimetech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: kernel: fixed style warnings in acct.c
Message-ID: <20141205110412.GA7840@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	"Joshua I. James" <joshua@cybercrimetech.com>,
	linux-kernel@vger.kernel.org
References: <1417754854-6576-1-git-send-email-Joshua@cybercrimetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417754854-6576-1-git-send-email-Joshua@cybercrimetech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua,

On Fri, Dec 05, 2014 at 01:47:34PM +0900, Joshua I. James wrote:
> From: "Joshua I. James" <joshua@cybercrimetech.com>
> 
> Fixed style errors identified by checkpatch.
> 
> Output of checkpatch:
> WARNING: Missing a blank line after declarations
> WARNING: line over 80 characters
> ERROR: spaces required around that '==' (ctx:VxV)
> +#if ACCT_VERSION==2
> 

It looks like your patch is making three types of changes. A single
patch should make a single type of change.  For example, you might fix
all the "blank line after declaration" warnings in one patch.

Doing this helps make your patches easier to review, and if a problem
arises later, easier to bisect.

> Signed-off-by: Joshua I. James <joshua@cybercrimetech.com>
> ---
>  kernel/acct.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index 33738ef..322159c 100644
> --- a/kernel/acct.c
[...]

It also looks like you only sent this to the linux-kernel mailing list.
You should use scripts/get_maintainer.pl to find who to send it to.

Hope that helps :-)

-- 
- Jeremiah Mahler
