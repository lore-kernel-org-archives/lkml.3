Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628Ab3DIS7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:59:33 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:49978 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262Ab3DIS7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:59:32 -0400
Message-ID: <5164650F.50405@gmail.com>
Date: Tue, 09 Apr 2013 20:59:27 +0200
From: Milan Broz <gmazyland@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: Milan Broz <gmazyland@gmail.com>, Mike Snitzer <msnitzer@redhat.com>,
        dm-crypt@saout.de, Christian Schmidt <schmidt@digadd.de>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-crypt] [dm-devel] dm-crypt performance
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com> <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com> <Pine.LNX.4.64.1304091352320.10025@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1304091352320.10025@file.rdu.redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.4.2013 20:08, Mikulas Patocka wrote:
> 
> 
> On Tue, 26 Mar 2013, Milan Broz wrote:
> 
>> - Are we sure we are not inroducing some another side channel in disc
>> encryption? (Unprivileged user can measure timing here).
>> (Perhaps stupid reason but please do not prefer performance to security
>> in encryption. Enough we have timing attacks for AES implementations...)
> 
> So use serpent - it is implemented without any data-dependent lookup 
> tables, so it has no timing attacks.

I wish using something different than AES is just such simple technical issue
for many people. But e.g. just try it in FIPS mode where AES is the only option:-)

Anyway, using bio_associate_current() seems to be the right way to try now...

Milan
