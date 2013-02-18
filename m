Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3BRQLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:11:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58009 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BRQLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:11:08 -0500
Date: Tue, 19 Feb 2013 01:11:05 +0900 (JST)
Message-Id: <20130219.011105.197738964.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/13] vmcore: modify ELF32 code according to new type
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130215153048.GD27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
	<20130214101210.22466.36330.stgit@localhost6.localdomain6>
	<20130215153048.GD27784@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 05/13] vmcore: modify ELF32 code according to new type
Date: Fri, 15 Feb 2013 10:30:48 -0500

> On Thu, Feb 14, 2013 at 07:12:10PM +0900, HATAYAMA Daisuke wrote:
>> On elf32 mmap() is not supported. All vmcore objects are in old
>> memory.
> 
> This is odd. Why can't we support mmap() when 32bit headers have been
> prepared?
> 
> Thanks
> Vivek
> 

I didin't think there's much usecase on ELF32 interface as I wrote in
the last patch description, but OK, I'll implement it on 32-bit
interface too.

Thanks.
HATAYAMA, Daisuke

