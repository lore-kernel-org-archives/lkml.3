Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3COJqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:46:21 -0400
Received: from mx02.infracom.it ([62.196.48.11]:27944 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab3COJqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:46:20 -0400
Message-ID: <5142EDEA.9070509@infracom.it>
Date: Fri, 15 Mar 2013 10:46:18 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>
Subject: Re: Regression: Fixing recursive fault but reboot is needed at boot
 on HP 6730B - bisected
References: <513D8F3A.8030308@gmail.com> <51418863.8000902@infracom.it> <1363271833.12845.186.camel@misato.fc.hp.com>
In-Reply-To: <1363271833.12845.186.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/03/2013 15:37, Toshi Kani ha scritto:
> By the boot failure, are you referring the one that is partially
> captured in screeshot3.png?

yes

> If so, we need full error messages (i.e.
> the top of the stack trace) to see what happened.

I'll try to get it, but it could take some time (I hope
to be able to work on it during next week end).

Kind regards
R

