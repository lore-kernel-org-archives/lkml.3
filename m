Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaESStM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:49:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:52587 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaESStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140224162951.20485.57579.stgit@patser>
References: <20140224162607.20485.70967.stgit@patser>
	<20140224162951.20485.57579.stgit@patser>
Date: Mon, 19 May 2014 11:49:08 -0700
Message-ID: <CALAqxLWZvt3yF8kAQz1AnQMOv66qqN8jP_zQiPDpiDcVngAa0g@mail.gmail.com>
Subject: Re: [PATCH 4/6] android: convert sync to fence api, v5
From: John Stultz <john.stultz@linaro.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Colin Cross <ccross@google.com>, linux-media@vger.kernel.org,
        Rom Lemarchand <romlem@google.com>,
        Greg Hackmann <ghackmann@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 8:29 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Just to show it's easy.
>
> Android syncpoints can be mapped to a timeline. This removes the need
> to maintain a separate api for synchronization. I've left the android
> trace events in place, but the core fence events should already be
> sufficient for debugging.
>
> v2:
> - Call fence_remove_callback in sync_fence_free if not all fences have fired.
> v3:
> - Merge Colin Cross' bugfixes, and the android fence merge optimization.
> v4:
> - Merge with the upstream fixes.
> v5:
> - Fix small style issues pointed out by Thomas Hellstrom.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I ran this through a fairly simple unit test for the Android sw_sync
interface and it ran fine.  Also since Colin, Rom and Greg didn't seem
to have major objections last I spoke with them:

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john
