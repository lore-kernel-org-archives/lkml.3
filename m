Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaDUK0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:26:38 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:48468 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaDUK0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:26:36 -0400
MIME-Version: 1.0
In-Reply-To: <5354F1A1.7010200@ti.com>
References: <534DB1F9.8020105@semaphore.gr>
	<5354F1A1.7010200@ti.com>
Date: Mon, 21 Apr 2014 15:56:35 +0530
Message-ID: <CAKohpokgq=mHi5768=AVqTiRJ5UUBxgMWtpRuzQa2AntzGZZ7w@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] davinci: da850: Use cpufreq_for_each_entry macro
 for iteration
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        davinci-linux-open-source@linux.davincidsp.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 April 2014 15:53, Sekhar Nori <nsekhar@ti.com> wrote:
> I cannot test this (or even build this) since I do not have the patch
> which adds cpufreq_for_each_entry(). The change as such looks fine to
> me. Please prefix the subject line with "ARM: " as is the convention in
> ARM world.

In case you wanna have a look:

https://lkml.org/lkml/2014/4/15/695
