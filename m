Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3CNVB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:01:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53292 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3CNVBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:01:25 -0400
Date: Thu, 14 Mar 2013 14:00:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Li Zefan <lizefan@huawei.com>,
        Sasha Levin <sasha.levin@oracle.com>, ebiederm@xmission.com,
        Eric Dumazet <eric.dumazet@gmail.com>, CAI Qian <caiqian@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: 3.9-rc1 NULL pointer crash at find_pid_ns
Message-ID: <20130314210038.GD3725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <876213wmwt.fsf@xmission.com>
 <5138D001.8000409@oracle.com>
 <1362678371.15793.218.camel@edumazet-glaptop>
 <5138D377.6040406@oracle.com>
 <87boavrspd.fsf@xmission.com>
 <5138D8F2.5020900@oracle.com>
 <20130307182934.GY3268@linux.vnet.ibm.com>
 <513AEC65.8000008@huawei.com>
 <20130309155146.GR3268@linux.vnet.ibm.com>
 <20130314200054.GA5924@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314200054.GA5924@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031421-2876-0000-0000-00000663D0DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 04:00:54PM -0400, Dave Jones wrote:
> On Sat, Mar 09, 2013 at 07:51:46AM -0800, Paul E. McKenney wrote:
>  > On Sat, Mar 09, 2013 at 04:01:41PM +0800, Li Zefan wrote:
>  > 
>  > [ . . . ]
>  > 
>  > > > This way, "ptr" is executed exactly once, and the check and the
>  > > > hlist_entry() are both using the same value.
>  > > 
>  > > I just played with trinity, and triggered this bug in just a few mins,
>  > > and I tried Paul's proposed fix and it works.
>  > 
>  > Thank you for testing this!  Please see below for the patch.
>  > 
>  > Sasha, will you be pushing this or would you like me to do so?
> 
> [crickets]
> 
> Given this has been hanging for the better part of another week,
> Paul why not send it Linus so hopefully rc3 doesn't have this bug ?

Good point!  I sent a pull request.

							Thanx, Paul

