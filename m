Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaCAB1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 20:27:48 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41132 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaCAB1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 20:27:47 -0500
MIME-Version: 1.0
In-Reply-To: <20140301010737.GY22728@two.firstfloor.org>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-12-git-send-email-dzickus@redhat.com> <87ppm7aws9.fsf@tassilo.jf.intel.com>
 <20140228194422.GL25953@redhat.com> <20140301010737.GY22728@two.firstfloor.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 1 Mar 2014 01:27:27 +0000
X-Google-Sender-Auth: jizX5Xy-lUuVA-l2NzzCFSXbdos
Message-ID: <CAM9d7cgwHZPcaDbHggoTqO3AjOi-HO6bKTAA9-OGgVTVYb1nGw@mail.gmail.com>
Subject: Re: [PATCH 11/19] perf, c2c: Add in sort on physid
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Arnaldo Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        jmario@redhat.com, fowles@inreach.com,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Sat, Mar 1, 2014 at 1:07 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> I don't think I understand the problem enough to know what to fix.  I just
>> copied this piece of code from builtin-report.c and things seemed to work.
>>
>> Mind giving me some details and I can look at fixing it. :-)
>
> sort.c even though has all these sort keys only sorts by period.
> It should instead sort by all the specified keys in order instead.
>
> Namhyung looked at it at some point.

Yes, I'm working on it now, but I only have a little time.  Hopefully
I can send a rfc version next week..

Thanks,
Namhyung
