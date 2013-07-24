Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3GXTEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:04:51 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:54057 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752105Ab3GXTEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:04:48 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru D77217F540
Date: Wed, 24 Jul 2013 23:04:31 +0400
From: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
To: Tony Luck <tony.luck@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep warning in edac_create_sysfs_mci_device
Message-ID: <20130724190429.GL24717@sanechka.spb.ru>
References: <20130721144819.GJ24717@sanechka.spb.ru>
 <20130721190212.GA31470@pd.tnic>
 <CA+8MBb+GzRkj9M7gy9g5CvXfzMGCYXRXfTUycbojnspyrwvTeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+GzRkj9M7gy9g5CvXfzMGCYXRXfTUycbojnspyrwvTeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24 09:27, Tony Luck wrote:
> Fix was pulled into Linus' tree yesterday evening (Portland, OR timezone):
> 
> commit 88d84ac97378c2f1d5fec9af1e8b7d9a662d6b00
> Author: Borislav Petkov <bp@suse.de>
> Date:   Fri Jul 19 12:28:25 2013 +0200
> 
>     EDAC: Fix lockdep splat
> 
> Alexandra: Give it a test and let me and Boris know if you still see
> any problems.

Thank you, the fix works.  Now it is easier for me to find problems in my
modules...

-- 
Alexandra N. Kossovsky
OKTET Labs (http://www.oktetlabs.ru/)
e-mail: sasha@oktetlabs.ru
