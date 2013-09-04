Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258Ab3IDIK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 04:10:26 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54799 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756610Ab3IDIKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 04:10:24 -0400
Message-ID: <5226EAEA.1010606@hitachi.com>
Date: Wed, 04 Sep 2013 17:10:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Hemant Kumar <hkshaw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org
Subject: Re: Re: [PATCH 2/2] Support to perf to probe on SDT markers:
References: <20130903072944.4793.93584.stgit@hemant-fedora> <20130903073703.4793.32779.stgit@hemant-fedora> <8761uht6jk.fsf@sejong.aot.lge.com>
In-Reply-To: <8761uht6jk.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/04 16:00), Namhyung Kim wrote:
> On Tue, 03 Sep 2013 13:07:03 +0530, Hemant Kumar wrote:
>> This patch enables perf to probe on the marker name specified on the command line.
> 
> It looks like you didn't consider prelinked libraries.  You need to check
> the address of .stapsdt.base section too.  And obviously this patch
> ignores any argument the SDT has which I think pretty important info.
> But we can add it later once the uprobes arg fetch patches are in.

Agreed, I'd like to see the argument support afterward.
Thanks!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


