Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab3CLNC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:02:26 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:33051 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3CLNCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <1360706658-13468-1-git-send-email-andi@firstfloor.org>
References: <1360706658-13468-1-git-send-email-andi@firstfloor.org>
Date: Tue, 12 Mar 2013 14:02:24 +0100
Message-ID: <CABPqkBQQ6NuEdWFGjg1cU4VRWrYPFFYoegXmXfhwwFYQPUZOmQ@mail.gmail.com>
Subject: Re: Basic perf PMU support for Haswell v6
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am not seeing those patches in tip.git tree as of today.
What is still wrong with those patches? I think they
are good for providing the basic enablement for HSW.


On Tue, Feb 12, 2013 at 11:04 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> This is based on v7 of the full Haswell PMU support, but
> ported to the latest perf/core and stripped down to the
> bare bones
>
> Only for very extremly basic usage.
>
> Most interesting new features are not in this patchkit
> (full version is git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu5)
>
> Contains support for:
> - Basic Haswell PMU and PEBS support
> - Late unmasking of the PMI
> - Support for wide counters
>
> v2: Addressed Stephane's feedback. See individual patches for details.
> v3: now even more bite-sized. Qualifier constraints merged earlier.
> v4: Rename some variables, add some comments and other minor changes.
> Add some Reviewed/Tested-bys.
> v5: Address some minor review feedback. Port to latest perf/core
> v6: Add just some variable names, add comments, edit descriptions, some
> more testing, rebased to latest perf/core
>
> -Andi
