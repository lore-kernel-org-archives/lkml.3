Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab3GaJX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:23:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37294 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959Ab3GaJXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:23:54 -0400
Date: Wed, 31 Jul 2013 11:23:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
Message-ID: <20130731092351.GA4724@pd.tnic>
References: <20130724171347.GB29756@naverao1-tp.watson.ibm.com>
 <1374686598.18818.18.camel@joe-AO722>
 <51F10AA8.2050901@linux.vnet.ibm.com>
 <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com>
 <20130729135812.GD6634@pd.tnic>
 <CAErSpo6fbMmicX95j_wYkJRnQeJEZ_jQSm76j9ZN4sHP0C2Yhg@mail.gmail.com>
 <20130729144046.GE6634@pd.tnic>
 <CAErSpo69wNc1h6PyJhFfhdFzz0GOiM=SCCfrm-WO5XDFTFzcHw@mail.gmail.com>
 <20130729152230.GG6634@pd.tnic>
 <CAErSpo7fmr9tsvA2fWgVWaOO9=hzHt8=hhr49BPrW3KxZtGLuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAErSpo7fmr9tsvA2fWgVWaOO9=hzHt8=hhr49BPrW3KxZtGLuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 10:12:56AM -0600, Bjorn Helgaas wrote:
> Yep, fair enough.  Looks good to me.

Thanks. I've added the newline per Joe's suggestion, added your Acked-by
and will send it upwards soonish.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
