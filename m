Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774Ab3KVPOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:14:55 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36095 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3KVPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:14:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131122151036.GB10881@krava.brq.redhat.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
 <1385044427-13995-5-git-send-email-artagnon@gmail.com> <20131122151036.GB10881@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Fri, 22 Nov 2013 20:44:13 +0530
Message-ID: <CALkWK0m1dVSNarCOiYCXm6khguoCZ=+Eht68OR9CLkmjKZq-aA@mail.gmail.com>
Subject: Re: [INCOMPLETE PATCH 4/4] perf diff: give Ratio column an
 appropriate color
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> On Thu, Nov 21, 2013 at 08:03:47PM +0530, Ramkumar Ramachandra wrote:
>> In
>>
>>   $ perf diff -c ratio
>>
>> color the Ratio column using percent_color_snprintf().
>
> why is there 'INCOMPLETE' in the subject?

As explained in the segment below the diffstat:

The incomplete bit is marked using a TODO; removing two trailing '%'
symbols doesn't seem to work. Can someone please tell me how to fix
this problem?
