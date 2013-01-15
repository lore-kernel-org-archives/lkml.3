Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3AOVcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:32:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab3AOVcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:32:50 -0500
Message-ID: <50F5CAF2.1050207@suse.cz>
Date: Tue, 15 Jan 2013 22:32:34 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tiana Rakotovao Andriamahefa <rkmahefa@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: kconfig: qconf.cc: fix a compiliation error
 when using make xconfig
References: <1358047720-10358-1-git-send-email-rkmahefa@gmail.com> <50F31E2C.3050104@suse.cz> <20130114005449.GA5499@rak.local>
In-Reply-To: <20130114005449.GA5499@rak.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.1.2013 01:54, Tiana Rakotovao Andriamahefa wrote:
> Le dimanche 13 janvier 2013 à 09:50:52, Michal Marek a écrit :
>> On 13.1.2013 04:28, Tiana Rakotovao Andriamahefa wrote:
>>> When using make xconfig, the following compilation error appears :
>>>    /usr/include/qt3/qvaluelist.h:427:13: error: ‘ptrdiff_t’ does not name a type
>>> Including stddef.h in scripts/kconfig/qconf.cc permits to avoid this error.
>>
>> This is a bug in the Qt header. Is Qt3 still maintained?
> 
> This seems to be a common c++ issue since the begining of 2011.
> 
> Some Qt3 headers use ptrdiff_t which is defined in stddef.h. They also use some 
> c++ headers, and rely on them to include stddef.h. However, since GCC-4.6, 
> those c++ headers do not include stddef.h anymore. So, include <stddef.h> 
> fixes it.

Right. My question is - is Qt3 still maintained somehow, so the includes
can be added where they belong, or do we need to workaround in in the
applications?

Michal

