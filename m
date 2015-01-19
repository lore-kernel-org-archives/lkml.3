Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbbASPXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:23:45 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:55136 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbbASPXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:23:44 -0500
Date: Mon, 19 Jan 2015 16:23:54 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: lee.jones@linaro.org, johan@kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] DLN2 fixes related to suspend/resume
Message-ID: <20150119152354.GU30960@localhost>
References: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421668296-28470-1-git-send-email-octavian.purdila@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 01:51:34PM +0200, Octavian Purdila wrote:
> Hi Lee,
> 
> Here is the 3rd version of the patch-set against for-mfd-next branch
> with the Reviewed-by tags from Johan. Note that I dropped the two GPIO
> patches as they were already merged by Linus W in the GPIO tree.
> 
> Thanks,
> Tavi
> 
> Changes since v2:
> 
>  * Dropped the GPIO fixes from this series as they were merged in the
>    GPIO tree
> 
>  * Removed a stray newline
> 
>  * Updated the resume / suspend patch commit with more information
>    about which cases it fixes and which it does not

Update looks good too.

Thanks,
Johan
