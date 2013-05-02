Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3EBHqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:46:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3EBHqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:46:07 -0400
Message-ID: <518219BD.9090208@suse.de>
Date: Thu, 02 May 2013 09:46:05 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: ZX <jencce.kernel@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: linux-next: Tree for May 1
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au> <alpine.DEB.2.02.1305021529430.23933@M2420>
In-Reply-To: <alpine.DEB.2.02.1305021529430.23933@M2420>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 09:37 AM, ZX wrote:
> 
> 
> On Wed, 1 May 2013, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Please do not add any v3.11 destined work to your linux-next included
>> branches until after v3.10-rc1 is released.
>>
>> Changes since 20130430:
>>
>> The nfsd tree lost its build failure.
>>
>> The xfs tree lost its build failure.
>>
>> The vfs tree gained conflicts against Linus' and the powerpc trees and
>> gained a build failure for which I applied a merge fix patch.
>>
>> The drm-intel tree gained a conflict against the drm tree.
>>
>> The block tree gained a conflict against Linus' tree.
>>
>> The arm-soc tree gained a conflict against the arm tree.
>>
>> The akpm tree lost a lot of patches that turned up elsewhere.
>>
>> ----------------------------------------------------------------------------
> 
> randconf build failure:
> 
> make -C drivers/scsi/aic7xxx/aicasm
> *** Install db development libraries
> gcc -I/usr/include -I. aicasm.c aicasm_symbol.c aicasm_gram.c 
> aicasm_macro_gram.c aicasm_scan.c aicasm_macro_scan.c -o aicasm -ldb
> aicasm_symbol.c:48:19: fatal error: aicdb.h: No such file or directory
> compilation terminated.
> 
> 
> random config file attached.
> 
> 
You need to install berkeley db ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
