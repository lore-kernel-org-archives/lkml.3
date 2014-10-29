Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbaJ2R63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:58:29 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53419 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2R6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:58:22 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-pm@vger.kernel.org (open list:SUSPEND TO RAM),
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] PM / Runtime: Rework RPM get callback routines
References: <1413543482-12748-1-git-send-email-a.hajda@samsung.com>
Date: Wed, 29 Oct 2014 10:58:18 -0700
In-Reply-To: <1413543482-12748-1-git-send-email-a.hajda@samsung.com> (Andrzej
	Hajda's message of "Fri, 17 Oct 2014 12:58:02 +0200")
Message-ID: <7hd29aahc5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrzej Hajda <a.hajda@samsung.com> writes:

> PM uses three separate functions to fetch RPM callbacks.
> These functions uses quite complicated macro in their body.
> The patch replaces these routines with one small macro and
> one helper function.
>
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>

Acked-by: Kevin Hilman <khilman@linaro.org>
