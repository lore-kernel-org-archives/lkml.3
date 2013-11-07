Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3KGJbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:31:44 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:64037 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3KGJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:31:42 -0500
MIME-Version: 1.0
In-Reply-To: <xmqqbo1x6q32.fsf@gitster.dls.corp.google.com>
References: <xmqqbo1x6q32.fsf@gitster.dls.corp.google.com>
Date: Thu, 7 Nov 2013 10:31:40 +0100
Message-ID: <CAP8UFD0faEZNU0A+r8eQTSKH84QqrT2wdeLWkGWx+NvoucKG5w@mail.gmail.com>
Subject: Re: [ANNOUNCE] Git v1.8.5-rc1
From: Christian Couder <christian.couder@gmail.com>
To: Junio C Hamano <gitster@pobox.com>
Cc: git <git@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 12:57 AM, Junio C Hamano <gitster@pobox.com> wrote:
>
>  * "git replace" helper no longer allows an object to be replaced with
>    another object of a different type to avoid confusion (you can
>    still manually craft such replacement using "git update-ref", as an
>    escape hatch).

Maybe it would be more helpful to say "you can still do that using the
--force option" instead of pointing people to "git update-ref".

Thanks,
Christian.
