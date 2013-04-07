Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339Ab3DGChw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 22:37:52 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55452 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161234Ab3DGChv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 22:37:51 -0400
MIME-Version: 1.0
In-Reply-To: <1365302138-19736-1-git-send-email-mcgrof@do-not-panic.com>
References: <1365302138-19736-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 6 Apr 2013 19:37:29 -0700
X-Google-Sender-Auth: dM0_1Re6PtvJfTuT6c3i28FjWMM
Message-ID: <CAB=NE6UgJoQzwrCzdc0P04vSRHGK4FtNEcJTBnN0nsQSKDviEw@mail.gmail.com>
Subject: Re: [PATCH 0/3] backports: adds regulator and media susbsystems
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 6, 2013 at 7:35 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Segmentation fault
> make[8]: *** [/home/mcgrof/tmp/build/compat/core.o] Error 139

And sorry, *this* set should have gone out as RFCs, not PATCH. The
other 9 should be fine if we just run ckmake to test them.

  Luis
