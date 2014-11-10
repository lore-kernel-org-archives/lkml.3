Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaKJCeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 21:34:12 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:43068 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKJCeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 21:34:11 -0500
MIME-Version: 1.0
In-Reply-To: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
Date: Mon, 10 Nov 2014 12:34:09 +1000
Message-ID: <CAPM=9tyej9J13U0c+-DH-EYw_4JJQbiQM98QREZQLz4PPj+FmQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/24] AMDKFD Kernel Driver
From: Dave Airlie <airlied@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 November 2014 04:37, Oded Gabbay <oded.gabbay@amd.com> wrote:
> Hi,
> Here is the v5 patch set of amdkfd.
>
> This version is released several days ahead of the release of AMD's HSA Runtime
> library as Open Source. Coupled with the modification that Thomas Stellard
> did for the r600 LLVM back-end, AMD will be effectively releasing a _complete_
> userspace Open Source stack/solution for running HSA applications using
> kernels written in OpenCL C99 on top of amdkfd.
>

Daniel pointed out too me a major problem with the approach of having
two drivers
touching on hw at all, they are facing similiar issues with their virt stuff,

How does amdkfd interfact with runtime pm on the radeon driver? I'd expect
some calls to the runtime get/put functions in some places.

Dave.
