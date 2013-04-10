Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936686Ab3DJOwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:52:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41425 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935636Ab3DJOwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:52:17 -0400
Date: Wed, 10 Apr 2013 16:52:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: checkpatch: kill the bogus camelcase check
Message-ID: <20130410145213.GA6854@pd.tnic>
References: <1365544254.2946.53.camel@dabdike>
 <20130410132628.GV7511@dm>
 <1365604558.27174.36.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1365604558.27174.36.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 07:35:58AM -0700, Joe Perches wrote:
> or maybe exclude drivers/scsi and include/scsi/

and arch/x86/kvm/emulate.c

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
