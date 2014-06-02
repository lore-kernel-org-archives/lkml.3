Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaFBTvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:51:23 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37154 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaFBTvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:51:22 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v7 0/2] context tracker support for arm64
References: <1401478455-26391-1-git-send-email-larry.bassel@linaro.org>
Date: Mon, 02 Jun 2014 12:51:19 -0700
In-Reply-To: <1401478455-26391-1-git-send-email-larry.bassel@linaro.org>
	(Larry Bassel's message of "Fri, 30 May 2014 12:34:13 -0700")
Message-ID: <7hvbsjw0nc.fsf@paris.lan>
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
>
> Changes v6 to v7:
>
> * Rename parameter of ct_user_exit from restore to syscall

Also for v7:

Reviewed-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin
