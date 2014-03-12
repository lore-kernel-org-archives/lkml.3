Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaCLKTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:19:50 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:53156 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaCLKTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:19:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140212100939.GB13441@mudshark.cambridge.arm.com>
References: <1391451509-31265-1-git-send-email-jean.pihet@linaro.org>
	<CAFrcx1mBWnO7mivQtGY1qLfd=KwV4ehyZoq0tV7buMiWKrTqrQ@mail.gmail.com>
	<20140212100939.GB13441@mudshark.cambridge.arm.com>
Date: Wed, 12 Mar 2014 11:19:48 +0100
Message-ID: <CAFrcx1mqiCRAscUN0t-GwpdX9B_kEii+fq8cH0kVbo+0=6YgVA@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] perf: AARCH64 arch support
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Gentle ping on this series? Which tree is it supposed to land in?

I have a new series about libdw integration and unwinding built-in
test for AARCH64, which is based on this one. How to handle it?

Regards,
Jean

On 12 February 2014 11:09, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Feb 12, 2014 at 08:47:17AM +0000, Jean Pihet wrote:
>> Ping on the series. Is this OK for inclusion?
>
> I already acked it all, but you'll need to wait until the next merge window
> since this isn't a fix.
>
> Will
