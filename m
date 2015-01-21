Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbbAUTS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:18:26 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:50383 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbbAUTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:18:18 -0500
Message-ID: <54BFFBA1.8060403@gmail.com>
Date: Wed, 21 Jan 2015 12:18:57 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 08/36] perf build: Add builtin objects building
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org> <1421771973-6022-9-git-send-email-jolsa@kernel.org> <54BFF557.1070809@gmail.com> <20150121191223.GF6835@krava.brq.redhat.com>
In-Reply-To: <20150121191223.GF6835@krava.brq.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/15 12:12 PM, Jiri Olsa wrote:
> hum I can't reproduce, but I can see why

I'm using a 16-cpu box, so perf build defaults to 16 jobs. Perhaps you 
are getting lucky with the build ordering?

