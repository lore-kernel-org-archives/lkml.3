Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaDAG1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:27:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbaDAG1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:27:06 -0400
Date: Tue, 1 Apr 2014 08:27:03 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        jerome.oufella@savoirfairelinux.com
Subject: Re: [lm-sensors] [PATCH] misc: (ds1682) replace obsolete
 simple_strtoull() with kstrtoull()
Message-ID: <20140401082703.6782c30c@endymion.delvare>
In-Reply-To: <1395864664-16404-1-git-send-email-sebastien.bourdelin@savoirfairelinux.com>
References: <1395864664-16404-1-git-send-email-sebastien.bourdelin@savoirfairelinux.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastien, 

On Wed, 26 Mar 2014 16:11:04 -0400, Sebastien Bourdelin wrote:
> simple_strtoull() is obsolete, use the newer kstrtoull() instead.
> 
> Signed-off-by: Sebastien Bourdelin <sebastien.bourdelin@savoirfairelinux.com>
> ---
>  drivers/misc/ds1682.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> (...)

You are sending this patch to the wrong list. The ds1682 driver has
nothing to do with lm-sensors. Please use ./scripts/get_maintainer.pl
to figure out who this patch should be sent to.

-- 
Jean Delvare
SUSE L3 Support
