Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbaJ2Ppe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:45:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbaJ2PmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:07 -0400
Date: Wed, 29 Oct 2014 17:23:50 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Cheng-Yi He <chengyihetaipei@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dgnc: fix macro coding style issue in digi.h
Message-ID: <20141029092350.GA723@kroah.com>
References: <1414519958-20457-1-git-send-email-chengyihetaipei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414519958-20457-1-git-send-email-chengyihetaipei@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 02:12:38AM +0800, Cheng-Yi He wrote:
> This is a patch to the digi.h file that fixes up the following error
> found by the checkpatch tool.
> ERROR: Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Cheng-Yi He <chengyihetaipei@gmail.com>
> ---
>  drivers/staging/dgnc/digi.h | 60 ++++++++++++++++++++++-----------------------
>  1 file changed, 30 insertions(+), 30 deletions(-)

You didn't test build this patch :(
