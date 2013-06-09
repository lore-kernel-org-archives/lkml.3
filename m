Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3FIG6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 02:58:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3FIG6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 02:58:49 -0400
Message-ID: <51B427A4.9030805@canonical.com>
Date: Sun, 09 Jun 2013 08:58:44 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [vt_console_print/cirrus_dirty_update] WARNING: at kernel/mutex.c:858
 mutex_trylock()
References: <20130606013518.GA9092@localhost> <51B038E3.30800@canonical.com> <20130606072856.GA32274@localhost>
In-Reply-To: <20130606072856.GA32274@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 06-06-13 09:28, Fengguang Wu schreef:
> Hi Maarten,
>
> Thanks for the patch! I'll queue it for the tests.
>
> <snip>
I haven't heard back from you yet, did it fix all lockdep issues you were having?
If so I'll get it queued.

~Maarten
