Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3LROoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3LROoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:44:23 -0500
Date: Wed, 18 Dec 2013 15:44:01 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        patches@linaro.org, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] perf: unwind: use the dwarf info only if loaded
Message-ID: <20131218144401.GE4146@krava.brq.redhat.com>
References: <1387212194-8028-1-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387212194-8028-1-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 05:43:14PM +0100, Jean Pihet wrote:
> Use the info only if it has been found in the .debug_frame
> section of the ELF binary.
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>

I couldn't test, but it looks ok

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
