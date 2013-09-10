Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3IJTOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:14:33 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47111 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab3IJTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:14:32 -0400
Message-ID: <522F6F96.8030803@gmail.com>
Date: Tue, 10 Sep 2013 12:14:30 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jean Pihet <jean.pihet@linaro.org>
CC: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case .eh_frame
 is not present
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org> <1378720815-23964-4-git-send-email-jean.pihet@linaro.org>
In-Reply-To: <1378720815-23964-4-git-send-email-jean.pihet@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/9/13 3:00 AM, Jean Pihet wrote:
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 7014373..54532b8 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -222,7 +222,7 @@ endif
>
>   FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
>   ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
> -  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
> +  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
>     NO_LIBUNWIND := 1
>   endif # Libunwind support
>   endif # NO_LIBUNWIND

Is the 1.1 version required for x86 too?

David
