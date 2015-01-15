Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbbAOPut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:50:49 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58770 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbAOPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:50:48 -0500
Message-ID: <54B7E1D0.1050805@gmail.com>
Date: Thu, 15 Jan 2015 08:50:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/36] tools build: Add detected config support
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org> <1421326532-25660-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421326532-25660-3-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/15/15 5:54 AM, Jiri Olsa wrote:
> Adding support to include detected configuration makefile
> into the build process. This will allow the Build objects
> to be configurable based on the config data, like:
>
>    perf-$(CONFIG_KRAVA) += krava.o
>
> The configuration is stored in '.config-detected' file,
> which is generated for each compilation.

So this file is similar to kernel's .config file and is generated based 
on today's autoprobing?

