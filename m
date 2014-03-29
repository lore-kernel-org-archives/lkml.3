Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562AbaC2AFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaC2AFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:05:46 -0400
Date: Fri, 28 Mar 2014 20:05:30 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jkosina@suse.cz, dh.herrmann@gmail.com
Subject: Re: [PATCH 1/1] Drivers: hid: hid-hyperv: Implement a stub
 raw_request() entry point
Message-ID: <20140329000530.GC7667@mail.corp.redhat.com>
References: <1396053687-21421-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1396053687-21421-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 28 2014 or thereabouts, K. Y. Srinivasan wrote:
> commit 3c86726cfe38952f0366f86acfbbb025813ec1c2
> Author: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Date:   Thu Feb 20 15:24:49 2014 -0500
> 
>     HID: make .raw_request mandatory
> 
>     SET_REPORT and GET_REPORT are mandatory in the HID specification.
>     Make the corresponding API in hid-core mandatory too, which removes the
>     need to test against it in some various places.
> 
>     Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>     Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>     Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> Made .raw_request mandatory and broke the Hyper-V mouse driver. This patch
> fixes the problem.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Thanks for spotting and fixing this K. Y.

Cheers,
Benjamin
