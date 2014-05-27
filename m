Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaE0Mfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:35:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbaE0Mfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:35:31 -0400
Date: Tue, 27 May 2014 08:34:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [RFC PATCH 00/11][V2] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140527123446.GB10994@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <20140526082514.GA25732@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526082514.GA25732@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:25:14AM +0200, Borislav Petkov wrote:
> Hi Vivek,
> 
> On Mon, Jan 27, 2014 at 01:57:40PM -0500, Vivek Goyal wrote:
> > Hi
> > 
> > This is V2 of new system call patches. Previous version was posted here.
> 
> just a quick ping here, are you working on a v3? Anything I can help with?

Hi Boris,

Yes, I am working on V3. I have been doing some more work to complete the
series. Specifically make the patches work with UEFI system and also wrote
code for verifying PKCS7 signature of bzImage. Signature verification code
I will post separately.

I am just battling a weared race condition where nested kdump seems to
fail on UEFI system sometimes. Some checksum issue. Hopefully I will be able
to resolve soon and repost patches for review.

Thanks
Vivek
