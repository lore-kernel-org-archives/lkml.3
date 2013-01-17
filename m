Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3AQOp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:45:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3AQOp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:45:56 -0500
Message-ID: <1358433952.12500.3.camel@ergine>
Subject: Re: [PATCH 42/86] drivers/gpu/drm/cirrus: remove depends on
 CONFIG_EXPERIMENTAL
From: Adam Jackson <ajax@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 17 Jan 2013 09:45:52 -0500
In-Reply-To: <1358391258-1771-43-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	 <1358391258-1771-43-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 18:53 -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.

Reviewed-by: Adam Jackson <ajax@redhat.com>

- ajax

