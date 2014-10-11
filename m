Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaJKQpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:45:23 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:64560 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJKQpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:45:22 -0400
MIME-Version: 1.0
In-Reply-To: <20141011131618.GA4043@lerouge>
References: <1412990134-31186-1-git-send-email-linux@roeck-us.net>
	<20141011131618.GA4043@lerouge>
Date: Sat, 11 Oct 2014 09:45:21 -0700
Message-ID: <CAADnVQK+E94r2YvbOa+_VdDqvU0ywGaAtQfXy6k2qQu8rfNoOA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Fix compile error seen in non-SMP builds
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 6:16 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> Note, ARM64 is one of the archs I couldn't test due to the lack of a
> nolibc cross compiler in https://www.kernel.org/pub/tools/crosstool/

that table is not up to date. There is one there for aarch64:
https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.9.0/
