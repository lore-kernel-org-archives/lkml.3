Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3K0Los (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:44:48 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:50317 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024Ab3K0Lon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:44:43 -0500
Date: Wed, 27 Nov 2013 11:44:40 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>, "richard@nod.at" <richard@nod.at>,
        Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH v2] efi-pstore: Make efi-pstore return a unique id
Message-ID: <20131127114440.GF18170@console-pimps.org>
References: <87bo1bnxhi.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo1bnxhi.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Nov, at 07:55:37PM, Madper Xie wrote:
> 
> Pstore fs expects that backends provide a uniqued id which could avoid
> pstore making entries as duplication or denominating entries the same
> name. So I combine the timestamp, part and count into id.
> 
> Signed-off-by: Madper Xie <cxie@redhat.com>
> ---
>  drivers/firmware/efi/efi-pstore.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)

Thanks unless anyone complains, I'm going to apply this.

Does this need to be tagged for stable?

-- 
Matt Fleming, Intel Open Source Technology Center
