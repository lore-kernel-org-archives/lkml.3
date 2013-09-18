Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab3IRPRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:17:33 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:62080 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3IRPRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:17:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvyZmjihgy4hqnbf+w9xgfMU_DOGLrnDL1CX3Z5PzkJkQ@mail.gmail.com>
References: <12400.1379338480@warthog.procyon.org.uk>
	<CAH2r5mvyZmjihgy4hqnbf+w9xgfMU_DOGLrnDL1CX3Z5PzkJkQ@mail.gmail.com>
Date: Wed, 18 Sep 2013 10:17:31 -0500
Message-ID: <CAH2r5msugEVeh6vzSkriHRcTZu2sxxRO63xc_pAVwU8AoD0ycw@mail.gmail.com>
Subject: Re: [GIT PULL] CIFS FS-Cache bugfix
From: Steve French <smfrench@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@redhat.com>, Sachin Prabhu <sprabhu@redhat.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        linux-cachefs@redhat.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git

On Mon, Sep 16, 2013 at 12:56 PM, Steve French <smfrench@gmail.com> wrote:
> On Mon, Sep 16, 2013 at 8:34 AM, David Howells <dhowells@redhat.com> wrote:
>>
>> Hi Steve,
>>
>> Could you pull a CIFS bugfix from my fscache branch?
>>
>> David
>
> Sounds fine.  May have to wait a day or so though due to pending merge
> request (to upstream).
>
>> ---
>> The following changes since commit 5a6f282a2052bb13171b53f03b34501cf72c33f1:
>>
>>   fscache: Netfs function for cleanup post readpages (2013-09-06 09:17:30 +0100)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git fscache
>>
>> for you to fetch changes up to 19ce0a7c9e94ae975e1c029b65b332cbf77b41ec:
>>
>>   CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before freeing them (2013-09-06 09:17:30 +0100)
>>
>> ----------------------------------------------------------------
>> David Howells (1):
>>       CIFS: FS-Cache: Uncache unread pages in cifs_readpages() before freeing them
>>
>>  fs/cifs/file.c    |  8 ++++++++
>>  fs/cifs/fscache.c |  7 +++++++
>>  fs/cifs/fscache.h | 13 +++++++++++++
>>  3 files changed, 28 insertions(+)
>
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
