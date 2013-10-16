Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978Ab3JPQlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:41:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53713 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab3JPQle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:41:34 -0400
Date: Wed, 16 Oct 2013 18:41:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, joe@perches.com, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
Message-ID: <20131016164119.GI13608@pd.tnic>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:56:00AM -0400, Chen, Gong wrote:
> GENMASK is used to create a contiguous bitmask([hi:lo]). It is
> implemented twice in current kernel. One is in EDAC driver, the other
> is in SiS/XGI FB driver. Move it to a more generic place for other
> usage.
> 
> Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Thomas Winischhofer <thomas@winischhofer.net>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
