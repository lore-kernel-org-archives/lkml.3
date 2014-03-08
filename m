Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCHUAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 15:00:31 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:58050 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbaCHUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 15:00:30 -0500
Message-ID: <1394308828.431.5.camel@x220>
Subject: Re: [PATCH] [RESEND] score: remove unused CPU_SCORE7 Kconfig
 parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Sat, 08 Mar 2014 21:00:28 +0100
In-Reply-To: <CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
References: <1386567192-19924-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <1394256390-10603-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <CAF0htA5OyL=cm7z5BMy1r7OcW_a-4WGEUbLzveR4fWgAC5av0Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2014 20:00:29.0174 (UTC) FILETIME=[0DF1F960:01CF3B09]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennox,

On Sat, 2014-03-08 at 14:34 +0800, Lennox Wu wrote:
> According to my record, I had told you we have another
> processor(2013/11/4), hence, we need the parameter.
> We just wirte it done first. Do you remember it?

In https://lkml.org/lkml/2011/11/12/76 I already reported that this
Kconfig symbol was unused. Why can't it be dropped and re-added when
code is added to the tree that actually uses it?


Paul Bolle

