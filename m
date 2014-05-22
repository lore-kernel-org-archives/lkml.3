Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaEVUTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:19:10 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40252 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEVUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:19:08 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v4 0/2] context tracker support for arm64
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
Date: Thu, 22 May 2014 13:19:06 -0700
In-Reply-To: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
	(Larry Bassel's message of "Thu, 22 May 2014 12:27:33 -0700")
Message-ID: <7h7g5dlg79.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Bassel <larry.bassel@linaro.org> writes:

> Implement and enable context tracking for arm64 (which is
> a prerequisite for FULL_NOHZ support). This patchset
> builds upon earlier work by Kevin Hilman and is based on
> Will Deacon's tree.

Tested-by: Kevin Hilman <khilman@linaro.org>

Test this with NO_HZ_FULL on v3.15-rc5 merged with the aarch64 branch
from Will's tree on the foundation model (with the DT modified so the
arch timer doesn't enter C3_STOP mode.)

Kevin
