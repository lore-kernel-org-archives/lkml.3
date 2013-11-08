Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3KHOet (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 09:34:49 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:51058 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118Ab3KHOer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 09:34:47 -0500
Date: Fri, 8 Nov 2013 14:34:21 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Richard Weinberger <richard@nod.at>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matt.fleming@intel.com,
        matthew.garrett@nebula.com, jlee@suse.com
Subject: Re: [PATCH] x86, efi: change name of efi_no_storage_paranoia
 parameter to efi_storage_paranoia
Message-ID: <20131108143421.GB22636@console-pimps.org>
References: <527C93B5.7010407@jp.fujitsu.com>
 <527C9B5C.6040509@nod.at>
 <527CB013.30200@jp.fujitsu.com>
 <527CB0F4.8080606@nod.at>
 <527CBC05.6080505@jp.fujitsu.com>
 <527CBD01.1000908@nod.at>
 <527CBDD3.2020609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527CBDD3.2020609@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Nov, at 07:32:51PM, Yasuaki Ishimatsu wrote:
> > Everything started with an issue that killed Samsung laptops:
> > http://mjg59.dreamwidth.org/22855.html
> > 
> > Later it was found that if you write too much into UEFI variables many
> > UEFI implementations will do bad things.
> 
> Thanks for the information.
> I will read it.

Out of curiosity, what hardware are you using?

-- 
Matt Fleming, Intel Open Source Technology Center
