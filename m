Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab3E1GRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:17:36 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:32770 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab3E1GRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:17:35 -0400
Date: Tue, 28 May 2013 01:17:31 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 2/7] Documentation/devices.txt: Mark /dev/oldmem
 obsolete
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <51A2BCCB.2090900@cn.fujitsu.com> (from
	zhangyanfei@cn.fujitsu.com on Sun May 26 20:54:19 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369721851.2776.37@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2013 08:54:19 PM, Zhang Yanfei wrote:
> 于 2013年05月27日 09:46, HATAYAMA Daisuke 写道:
> > (2013/05/26 15:36), Zhang Yanfei wrote:
> >> From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >>
> >> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> >> Cc: Dave Jones <davej@redhat.com>
> >> ---
> >>   Documentation/devices.txt |    3 +--
> >>   1 files changed, 1 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/devices.txt b/Documentation/devices.txt
> >> index 08f01e7..c8e4002 100644
> >> --- a/Documentation/devices.txt
> >> +++ b/Documentation/devices.txt
> >> @@ -100,8 +100,7 @@ Your cooperation is appreciated.
> >>            10 = /dev/aio        Asynchronous I/O notification  
> interface
> >>            11 = /dev/kmsg        Writes to this come out as  
> printk's, reads
> >>                       export the buffered printk records.
> >> -         12 = /dev/oldmem    Used by crashdump kernels to access
> >> -                    the memory of the kernel that crashed.
> >> +         12 = /dev/oldmem    OBSOLETE
> >>
> >>     1 block    RAM disk
> >>             0 = /dev/ram0        First RAM disk
> >>
> >
> > This is the new patch. Looking at other parts of devices.txt,  
> obsolete is
> > sometimes used together with unused. I guess obsolete means this is  
> old interface so
> > don't use it as much as possible and unused means this is not used  
> at all now.
> > You remove old memory interface completely in this patch set, so is  
> it better to add
> > unused, too?
> >
> 
> Does obsolete also mean "not used anymore"? I don't know. I think we  
> can wait for some native
> English speakers to comment on this.

Obsolete implies that it shouldn't be used anymore. There are  
exceptions to everything, of course...

(Unused means nothing is using it. If there's still code using it, it's  
not unused. So yeah unused would imply removed.)

Rob