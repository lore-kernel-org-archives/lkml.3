Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3LWHhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 02:37:09 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:41274 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab3LWHhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 02:37:07 -0500
Date: Mon, 23 Dec 2013 07:36:41 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Dave Young <dyoung@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "bp@alien8.de" <bp@alien8.de>, "greg@kroah.com" <greg@kroah.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "leif.lindholm@linaro.org" <leif.lindholm@linaro.org>
Subject: Re: [PATCH v7 00/12] kexec kernel efi runtime support
Message-ID: <20131223073641.GA28919@console-pimps.org>
References: <1387533742-18018-1-git-send-email-dyoung@redhat.com>
 <20131221173515.GE29501@console-pimps.org>
 <1387747621.1848.2.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387747621.1848.2.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Dec, at 02:27:01PM, Toshi Kani wrote:
> 
> The kexec branch is missing the following change, which is required for
> fast reboot with multi-cpus.
> 
>    commit 279f1df915c3a6ed3075d98a849705bf53851f99
>    Author: Vivek Goyal <vgoyal@redhat.com>
>    Date:   Tue Nov 26 10:25:28 2013 +0800
> 
>        kexec: migrate to reboot cpu
> 
> With this change added, I confirmed that the branch kernel works fine.
 
I can't find that commit in Linus' tree. Where is it from?

-- 
Matt Fleming, Intel Open Source Technology Center
