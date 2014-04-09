Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbaDILLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:11:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48765 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597AbaDILLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:11:35 -0400
Date: Wed, 9 Apr 2014 13:11:29 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jason Baron <jbaron@akamai.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
Message-ID: <20140409111129.GH6529@pd.tnic>
References: <cover.1396645124.git.jbaron@akamai.com>
 <760765424abe31811027ff3efd078bc858b7d3ed.1396645124.git.jbaron@akamai.com>
 <20140408090924.GE30077@pd.tnic>
 <5344754B.8050909@akamai.com>
 <3908561D78D1C84285E8C5FCA982C28F31E21864@ORSMSX106.amr.corp.intel.com>
 <5344B86C.8000905@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5344B86C.8000905@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 11:03:08PM -0400, Jason Baron wrote:
> Hmmm...as I said, I'm not getting any machine checks with ue errors.
> I've got a fairly old kernel on the system atm, I will try loading a
> newer kernel, to see if that makes any difference...

Well, regardless of the kernel, if the machine encounters an UE, it
would explode. Can you confirm those are *actually* UEs and they're
getting consumed?

Also, check MCG_CAP, i.e.:

# rdmsr 0x179

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
