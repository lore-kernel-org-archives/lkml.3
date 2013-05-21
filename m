Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3EUJEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:04:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:59518 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3EUJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:04:08 -0400
X-Spam-Score: -100.8
Message-ID: <519B3855.6050201@asianux.com>
Date: Tue, 21 May 2013 17:03:17 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        zhangyanfei@cn.fujitsu.com, Jiri Kosina <jkosina@suse.cz>,
        Michael Ellerman <michael@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PowerPC: kernel: need return the related error code when
 failure occurs.
References: <519B0ACA.6090008@asianux.com> <20130521081031.GA29303@iris.ozlabs.ibm.com>
In-Reply-To: <20130521081031.GA29303@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:10 PM, Paul Mackerras wrote:
> On Tue, May 21, 2013 at 01:48:58PM +0800, Chen Gang wrote:
>> > 
>> > When error occurs, need return the related error code to let upper
>> > caller know about it.
>> > 
>> > ppc_md.nvram_size() can return the error code (e.g. core99_nvram_size()
>> > in 'arch/powerpc/platforms/powermac/nvram.c').
>> > 
>> > And when '*ppos >= size', need return -ESPIPE (Illegal seek)
> Why?  When *ppos >= size, it should return 0 (end of file) in my opinion.
> ESPIPE means that any seek would be ineffective, not that a particular
> seek went out of bounds.

OK, thanks, I will send patch v2.  :-)


Thanks.
-- 
Chen Gang

Asianux Corporation
