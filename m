Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab3GXTNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:13:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54783 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3GXTNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:13:23 -0400
Date: Wed, 24 Jul 2013 21:13:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Tony Luck <tony.luck@gmail.com>, Doug Thompson <dougthompson@xmission.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep warning in edac_create_sysfs_mci_device
Message-ID: <20130724191316.GN30777@pd.tnic>
References: <20130721144819.GJ24717@sanechka.spb.ru>
 <20130721190212.GA31470@pd.tnic>
 <CA+8MBb+GzRkj9M7gy9g5CvXfzMGCYXRXfTUycbojnspyrwvTeQ@mail.gmail.com>
 <20130724190429.GL24717@sanechka.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130724190429.GL24717@sanechka.spb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:04:31PM +0400, Alexandra N. Kossovsky wrote:
> Thank you, the fix works. Now it is easier for me to find problems in
> my modules...

On Wed, Jul 24, 2013 at 02:37:56PM -0400, Peter Hurley wrote:
> Thanks for fixing this. Now I can fix the lockdep splat I just
> introduced to linux-next :(

Guys, we're so happy that we could help you concentrate solely on your
bugs.

:-) :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
