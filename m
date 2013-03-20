Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab3CTQqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:46:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48745 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933184Ab3CTQqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:46:09 -0400
Message-ID: <5149E7C3.3080707@zytor.com>
Date: Wed, 20 Mar 2013 09:45:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>  <51490ABD.3050205@zytor.com>  <1363785354.2553.15.camel@x230.sbx07502.somerma.wayport.net>  <db71c48c-4ec4-4611-935b-bb1b0441112d@email.android.com> <1363792462.2553.24.camel@x230.sbx07502.somerma.wayport.net>
In-Reply-To: <1363792462.2553.24.camel@x230.sbx07502.somerma.wayport.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 08:14 AM, Matthew Garrett wrote:
> On Wed, 2013-03-20 at 08:03 -0700, H. Peter Anvin wrote:
>> CAP_SYS_RAWIO is definitely inappropriate there.
> 
> Ok. How do we fix that without breaking userspace that expects
> CAP_SYS_RAWIO to be sufficient?
> 

I don't think we can to some way, because when what you have is
fundamentally broken, it's hard to fix.

However, it is extremely likely that the number of affected applications
is vanishingly small.  There probably are a handful of apps that do
this, and I wouldn't be surprised if most of them simply run as root.

	-hpa

