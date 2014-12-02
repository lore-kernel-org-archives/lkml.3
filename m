Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaLBLtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:49:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33827 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaLBLtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:49:24 -0500
Message-ID: <547DA742.1010806@suse.cz>
Date: Tue, 02 Dec 2014 12:49:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] limit _shipped to c h and S files
References: <20141202091621.GE13909@opentech.at> <547D924A.2010205@suse.cz> <20141202103231.GA30141@opentech.at>
In-Reply-To: <20141202103231.GA30141@opentech.at>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-02 11:32, Nicholas Mc Guire wrote:
> On Tue, 02 Dec 2014, Michal Marek wrote:
> 
>> Dne 2.12.2014 v 10:16 Nicholas Mc Guire napsal(a):
>>>
>>> limit _shipped to c h and S files
>>>
>>> _shipped targets are intended for generated source files which should
>>> not permit .o binary blobs which is currently the case. This patch
>>> simply restricts _shipped targets to .c, .h and .S files.
>>
>>
>> IMO this just adds lines of code without any obvious advantage. The
>> other patches in the series are fine.
>>
> 
> The idea simply was to make the behavior of kbuild match the
> documented intent of _shipped files.

The usage of *.o_shipped is documented by Documentation/kbuild/modules.txt.

Michal
