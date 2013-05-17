Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3EQFo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 01:44:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54007 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795Ab3EQFo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 01:44:27 -0400
Message-ID: <5195C37F.4090302@zytor.com>
Date: Thu, 16 May 2013 22:43:27 -0700
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
References: <20130515090507.28109.28956.stgit@localhost6.localdomain6> <51957469.2000008@zytor.com> <87y5bee2qc.fsf@xmission.com> <5195A223.2070204@zytor.com> <87vc6icjqo.fsf@xmission.com>
In-Reply-To: <87vc6icjqo.fsf@xmission.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 09:29 PM, Eric W. Biederman wrote:
> 
> Whatever theoretical issues you have with /dev/oldmem and /proc/vmcore
> can and should be talked about and addressed independently of these
> changes.

And they are... last I know Dave Hansen was looking at it.

	-hpa


