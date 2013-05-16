Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3EPWZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:25:38 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42926 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab3EPWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <68458966.ga8OpWyZtA@vostro.rjw.lan>
References: <68458966.ga8OpWyZtA@vostro.rjw.lan>
Date: Thu, 16 May 2013 15:25:35 -0700
X-Google-Sender-Auth: nkV_WMNrbcDMHz8wJDO0GlHrfrM
Message-ID: <CA+55aFxhDO0D1nQgTFWSiZT9AJMSF9oOUoxWj=Y=5en0nWC92g@mail.gmail.com>
Subject: Re: [GIT PULL] Power management and ACPI fixes for v3.10-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 1:07 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> - intel_pstate driver fixes and cleanups from Dirk Brandewie and
>   Wei Yongjun.

Btw, is there some fundamental reason why the pstate driver is limited
to so few models?

I've tested it on models 0x25 (i5-670) and 0x3a (i5-3427U), and it
seems to work. But neither model is listed. (only 0x2a and 0x2d are).

I understand that people want to be careful, but it's not actually
getting very much *testing* right now, is it? Are models 0x2a/0x2d
actually special in any way?

                  Linus
