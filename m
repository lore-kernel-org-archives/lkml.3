Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3CNWUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:20:10 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34567 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3CNWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:20:08 -0400
Date: Thu, 14 Mar 2013 15:20:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: bp@alien.de, chegger@amazon.de, xen-devel@lists.xen.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        JBeulich@suse.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/mce: Replace shared_bank array with
 is_shared_bank() helper
Message-ID: <20130314222005.GB28339@kroah.com>
References: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
 <1363295441-1859-2-git-send-email-boris.ostrovsky@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363295441-1859-2-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 05:10:40PM -0400, Boris Ostrovsky wrote:
> Use helper function instead of an array to report whether register
> bank is shared. Currently only bank 4 (northbridge) is shared.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce_amd.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
