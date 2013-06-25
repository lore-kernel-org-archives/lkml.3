Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3FYBGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 21:06:51 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64711 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3FYBGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 21:06:50 -0400
X-AuditID: 9c93017e-b7cd1ae000002371-53-51c8ed288de7
Message-ID: <51C8ED28.8010008@lge.com>
Date: Tue, 25 Jun 2013 10:06:48 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@kernel.org, hpa@zytor.com, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf sort: Separate out memory-specific sort
 keys
References: <1364991979-3008-3-git-send-email-namhyung@kernel.org> <tip-afab87b91f3f331d55664172dad8e476e6ffca9d@git.kernel.org> <20130625003010.GU6123@two.firstfloor.org> <51C8EBB5.3040000@lge.com> <20130625010231.GV6123@two.firstfloor.org>
In-Reply-To: <20130625010231.GV6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-06-25 AM 10:02, Andi Kleen wrote:
>> I'm not sure it should move to the common keys as normal perf
>> session won't have those.
>
> Why not? If I enable weight sampling i get weights perfectly
> fine in any session using the right PEBS events.
>
>> I guess you need to set up a couple of
>> TSX-specific sort keys like perf mem, if so what about moving the
>> two weights to your table?
>
> There's no TSX table and no separate perf TSX session.
> It's just some additional attributes.

Okay then, I have no objection for moving them. :)

Thanks,
Namhyung

