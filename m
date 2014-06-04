Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaFDMjH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:39:07 -0400
Received: from mx12.netapp.com ([216.240.18.77]:19463 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbaFDMjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:39:04 -0400
X-IronPort-AV: E=Sophos;i="4.98,973,1392192000"; 
   d="scan'208";a="168208754"
Message-ID: <538F1361.6060400@netapp.com>
Date: Wed, 4 Jun 2014 08:38:57 -0400
From: Anna Schumaker <Anna.Schumaker@netapp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: bad commits in the nfs tree
References: <20140604083411.4296bcd5@canb.auug.org.au> <CAABAsM4hpz_vCK=AbLUzBnVCr3-_5KhJUqif3YP3Yjp+-ojx8w@mail.gmail.com>
In-Reply-To: <CAABAsM4hpz_vCK=AbLUzBnVCr3-_5KhJUqif3YP3Yjp+-ojx8w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 06:46 PM, Trond Myklebust wrote:
> On Tue, Jun 3, 2014 at 6:34 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Trond,
>>
>> I noticed in the nfs tree this morning 2 commits that have been
>> cherry-picked from Linus' tree:
>>
>> cc6d854967ce    Linux 3.15-rc8
>> 2b267bb3a8e5    powerpc: Wire renameat2() syscall
>>
>> These are part of a branch that you merged from Anna Schumaker.  It
>> looks like they may have been included when Anna was trying to rebase
>> the rest of the branch onto v3.15-rc8?
>>
>> Please fix this up before asking Linus to pull your tree.
>>
> 
> Thanks Stephen! We're still ironing out the kinks in a new process for
> the NFS client maintenance, and appreciate your patience.
> 
> Anna, let's avoid the mess that is 3.15-rc8 for now. Please rebase on
> top of commit b5968725f46d (Push the file layout driver into a
> subdirectory) from my nfs-for-next branch and retag the resulting
> branch using the same commit information as earlier.
> I'll pull the new tag once you send the word that all is ready...

Sure.  I'll take care of that right away!

Anna
> 
> Thanks
>    Trond
> 

