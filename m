Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab3EQDWM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:22:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52881 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab3EQDWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:22:11 -0400
Message-ID: <5195A223.2070204@zytor.com>
Date: Thu, 16 May 2013 20:21:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, vgoyal@redhat.com,
        akpm@linux-foundation.org, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com, jingbai.ma@hp.com, linux-mm@kvack.org,
        riel@redhat.com, walken@google.com, hughd@google.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH v6 0/8] kdump, vmcore: support mmap() on /proc/vmcore
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <51957469.2000008@zytor.com> <87y5bee2qc.fsf@xmission.com>
In-Reply-To: <87y5bee2qc.fsf@xmission.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 07:53 PM, Eric W. Biederman wrote:
> 
> That is completely and totally orthogonal to this change.
> 
> read_oldmem may have problems but in practice on a large systems those
> problems are totally dwarfed by real life performance issues that come
> from playing too much with the page tables.
> 
> I really don't find bringing up whatever foundational issues you have
> with read_oldmem() appropriate or relevant here.
> 

Well, it is in the sense that we have two pieces of code doing the same
thing, each with different bugs.

	-hpa


