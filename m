Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934867Ab3BSXHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 18:07:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab3BSXHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 18:07:24 -0500
Date: Tue, 19 Feb 2013 18:07:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] vmcore: introduce types for objects copied in 2nd
 kernel
Message-ID: <20130219230717.GG6039@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
 <20130214101205.22466.5909.stgit@localhost6.localdomain6>
 <20130215152828.GC27784@redhat.com>
 <20130219.010631.336702748.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130219.010631.336702748.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2013 at 01:06:31AM +0900, HATAYAMA Daisuke wrote:

[..]
> This sounds strange to me. There has not been contents to be fetched
> from current kenrel so far. So, object with MEM_TYPE_OLDMEM seems more
> normal than without. Should we prepare special type for objects in 2nd
> kernel?

Creating a flag for memory in current kernel and if flag is not set, then
assuming memory comes from old kernel is fine too.

Thanks
Vivek
