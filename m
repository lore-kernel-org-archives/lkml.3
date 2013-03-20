Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908Ab3CTBEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 21:04:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42264 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932679Ab3CTBEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 21:04:05 -0400
Message-ID: <51490AF6.4080707@zytor.com>
Date: Tue, 19 Mar 2013 18:03:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/12] Security: Add CAP_COMPROMISE_KERNEL
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com> <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1303191542200.30973@tundra.namei.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 09:47 PM, James Morris wrote:
> On Mon, 18 Mar 2013, Matthew Garrett wrote:
> 
>> This patch introduces CAP_COMPROMISE_KERNEL. 
> 
> I'd like to see this named CAP_MODIFY_KERNEL, which is more accurate and 
> less emotive.  Otherwise I think core kernel developers will be scratching 
> their head over where to sprinkle this.
> 
> Apart from that, I like the idea, especially when it's wired up to MAC 
> security.

The wiring up to MAC security is a nice touch.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

