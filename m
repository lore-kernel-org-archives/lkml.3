Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896AbaLDE5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 23:57:41 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51861 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaLDE5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 23:57:40 -0500
Date: Wed, 3 Dec 2014 20:57:35 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH v12 01/19] input: cyapa: modify code to following kernel
 code style
Message-ID: <20141204045735.GA5362@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, linux-kernel@vger.kernel.org,
	dmitry.torokhov@gmail.com
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
 <1417599025-21681-2-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417599025-21681-2-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Wed, Dec 03, 2014 at 05:30:07PM +0800, Dudley Du wrote:
> This patch modified the code to fix the patch check warning issue with latest
> checkpatch.sh tool, and also changed the return variable name from "ret" to
> "error" when there is only one error path to follow code style.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> ---
>  drivers/input/mouse/cyapa.c | 162 ++++++++++++++++++++++----------------------
>  1 file changed, 80 insertions(+), 82 deletions(-)
> 
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index b409c3d..c9fdf6d 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
[...]

I was hoping to test out your patchset since the patch for the touchpad
problem [1] still has not appeared in linux-next as of 20141203.
Unfortunately your patchset does not apply so I can't test it.  Which
kernel is your work based off of?

  [1]: https://lkml.org/lkml/2014/11/27/684

-- 
- Jeremiah Mahler
