Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3CKPD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:03:28 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:48043 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab3CKPDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:03:25 -0400
X-Authority-Analysis: v=2.0 cv=XNeyuHdE c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=djqtFF5C5r8A:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=VrFzeNeFecIA:10 a=pSy6a87nxj3EpRuEWu0A:9 a=wPNLvfGTeEIA:10 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.78.168.186
Message-ID: <513DF239.2000806@ubuntu.com>
Date: Mon, 11 Mar 2013 11:03:21 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Howard Chu <hyc@symas.com>, Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
References: <5136320E.8030109@symas.com> <20130307154312.GG6723@quack.suse.cz> <20130308020854.GC23767@cmpxchg.org> <5139975F.9070509@symas.com> <20130308084246.GA4411@shutemov.name> <5139B214.3040303@symas.com> <5139FA13.8090305@genband.com> <5139FD27.1030208@symas.com> <513A8ECB.8000504@ubuntu.com> <20130311115220.GB29799@quack.suse.cz>
In-Reply-To: <20130311115220.GB29799@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2013 7:52 AM, Jan Kara wrote:
>> Yep, that's because it isn't implemented.
>    Why do you think so? AFAICS it is implemented by setting VM_RAND_READ
> flag in the VMA and do_async_mmap_readahead() and do_sync_mmap_readahead()
> check for the flag and don't do anything if it is set...

Oh, don't know how I missed that... I was just looking for it the other 
day and couldn't find any references to VM_RandomReadHint so I assumed 
it hadn't been implemented.


