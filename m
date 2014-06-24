Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbaFXKZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:25:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56830 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaFXKZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:25:33 -0400
Date: Tue, 24 Jun 2014 12:25:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: tony.luck@intel.com, mattieu.souchaud@free.fr, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mce: Don't unregister CPU hotplug notifier in error
 path
Message-ID: <20140624102531.GE4439@pd.tnic>
References: <1acfd8b6-48f1-4324-9723-224a7f4f7367@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1acfd8b6-48f1-4324-9723-224a7f4f7367@default>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 10:25:50AM -0700, Boris Ostrovsky wrote:
> You can add
>
> Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
> if you prefer to go with that version. I still think it's not 100%
> reliable (because of what I said above) but at least it fixes the
> current breakage.

Thanks.

The thing is, I don't like to address hypothetical breakages if they can
never be triggered on any configuration.

But I'm going to leave an open mind so if you still can trigger *with*
this fix, then we can revisit it then again.

Thanks for testing!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
