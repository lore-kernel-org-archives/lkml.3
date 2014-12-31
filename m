Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbaLaOzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 09:55:22 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:64472 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaLaOzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 09:55:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141231112603.GB1256@krava.brq.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-5-git-send-email-namhyung@kernel.org> <20141231112603.GB1256@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 31 Dec 2014 23:55:00 +0900
X-Google-Sender-Auth: V2K-KXbKBx58aJiCjvfPm_vys6c
Message-ID: <CAM9d7cjFG9AsoEiMux558iTvGmbe3uhy7fcMBUX=w+koYHU+YQ@mail.gmail.com>
Subject: Re: [PATCH 04/37] perf tools: Add multi file interface to perf_data_file
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2014 at 8:26 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:00PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +
>>  static int open_file_read(struct perf_data_file *file)
>>  {
>>       struct stat st;
>> +     char path[PATH_MAX];
>>       int fd;
>>       char sbuf[STRERR_BUFSIZE];
>>
>> -     fd = open(file->path, O_RDONLY);
>> +     strcpy(path, file->path);
>
> strncpy ?

Will change. :)

Thanks,
Namhyung
