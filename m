Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3DZQ07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:26:59 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:36875 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3DZQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:26:58 -0400
Message-ID: <517AAACD.10508@gmail.com>
Date: Fri, 26 Apr 2013 10:26:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 21/26] perf tools: Switch to full patch C include directories
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com> <1366796273-4780-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1366796273-4780-22-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/13 3:37 AM, Jiri Olsa wrote:
> Switching to full patch C include directories, to make
> the includes clear.

s/patch/path/ ?  email subject line too

David
