Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3JDKj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:39:27 -0400
Received: from relay.parallels.com ([195.214.232.42]:58456 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3JDKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:39:26 -0400
Message-ID: <524E9AB3.2080307@parallels.com>
Date: Fri, 4 Oct 2013 14:38:43 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Janani Venkataraman <jananive@in.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <amwang@redhat.com>,
        <rdunlap@xenotime.net>, <andi@firstfloor.org>,
        <aravinda@linux.vnet.ibm.com>, <hch@lst.de>, <mhiramat@redhat.com>,
        <jeremy.fitzhardinge@citrix.com>, <suzuki@linux.vnet.ibm.com>,
        <kosaki.motohiro@jp.fujitsu.com>, <adobriyan@gmail.com>,
        <tarundsk@linux.vnet.ibm.com>, <vapier@gentoo.org>,
        <roland@hack.frob.com>, <tj@kernel.org>, <ananth@linux.vnet.ibm.com>,
        <gorcunov@openvz.org>, <avagin@openvz.org>, <oleg@redhat.com>,
        <eparis@redhat.com>, <d.hatayama@jp.fujitsu.com>,
        <james.hogan@imgtec.com>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>
Subject: Re: [RFC] [PATCH 00/19] Non disruptive application core dump infrastructure
 using task_work_add()
References: <20131004102532.1612.24185.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.114]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 02:30 PM, Janani Venkataraman wrote:
> Hi all,
> 

> This series is based on the Task work add approach. We didn't adopt the CRIU
> approch because of the following reasons:
> 
> * It is not upstream yet.

It is, starting from criu-v0.7 + linux-3.11

> * There are concerns about the security of the dump.

Can you elaborate on this? Is it fixable in CRIU at all?

> * It involves a lot of changes and this approach provides a UNIX style 
>   interface.

Can you also shed more light on this -- what changes do you mean?
