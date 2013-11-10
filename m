Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab3KJGNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 01:13:30 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:45391 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3KJGN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 01:13:29 -0500
MIME-Version: 1.0
In-Reply-To: <1383557553-4762-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1383557553-4762-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Sun, 10 Nov 2013 10:13:28 +0400
Message-ID: <CAMo8BfLS_+wxKLZy5GS3Db-iEtJJ8VkJMOQep12kQm2B0tHL8g@mail.gmail.com>
Subject: Re: [PATCH] xtensa: remove unused XTENSA_ISS_NETWORK Kconfig parameter
From: Max Filippov <jcmvbkbc@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Chris Zankel <chris@zankel.net>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 4, 2013 at 1:32 PM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This removes the XTENSA_ISS_NETWORK Kconfig parameter,
> which was no longer used anywhere in the source code
> and Makefiles.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---

Thanks, taken to my xtensa tree.

-- Max
