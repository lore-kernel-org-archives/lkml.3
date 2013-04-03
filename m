Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875Ab3DCQ0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:26:34 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:57793 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578Ab3DCQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:26:32 -0400
Date: Wed, 3 Apr 2013 09:26:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Richard Guy Briggs'" <rbriggs@redhat.com>
Subject: Re: [PATCH 3.8-stable] thermal: return an error on failure to
 register thermal
Message-ID: <20130403162629.GA21969@kroah.com>
References: <000001ce3003$a1b87aa0$e5296fe0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001ce3003$a1b87aa0$e5296fe0$%choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 09:38:55AM +0900, Jonghwan Choi wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

Ok, I object, given that I told you to change the format of the message
you send out.  Please look at how others on the stable@ mailing list
send "should this patch be applied" messages, and copy how that is done.

> ------------------
> 
> From: "Richard Guy Briggs <rbriggs@redhat.com>"
> 
> commit da28d966f6aa942ae836d09729f76a1647932309 upstream.
> 
> The return code from the registration of the thermal class is used to
> unallocate resources, but this failure isn't passed back to the caller of
> thermal_init.  Return this failure back to the caller.
> 
> This bug was introduced in changeset 4cb18728 which overwrote the return
> code
> when the variable was re-used to catch the return code of the registration
> of
> the genetlink thermal socket family.

You linewrapped the patch message, careful, you might mess up the patch
itself as well :(

> Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

You aren't signing off on it as well?  Why not?

thanks,

greg k-h
