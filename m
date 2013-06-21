Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916Ab3FUA7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965307Ab3FUA7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:59:10 -0400
Date: Fri, 21 Jun 2013 01:59:05 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Geremy Condra <gcondra@google.com>
Cc: dm-devel@redhat.com, wad@chromium.org, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [dm-devel] [PATCH] dm: verity: Add support for emitting
	uevents on dm-verity errors.
Message-ID: <20130621005905.GI23042@agk-dp.fab.redhat.com>
Mail-Followup-To: Geremy Condra <gcondra@google.com>, dm-devel@redhat.com,
	wad@chromium.org, linux-kernel@vger.kernel.org, agk@redhat.com
References: <1371763260-9933-1-git-send-email-gcondra@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371763260-9933-1-git-send-email-gcondra@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 02:21:00PM -0700, Geremy Condra wrote:
> With this change and config option, dm-verity errors
> will cause uevents to be sent to userspace, notifying
> it that an error has occurred and potentially
> triggering recovery actions.
 
> +config DM_VERITY_ERROR_NOTIFY
> +	tristate "Notify userspace of verity errors through uevents"
> +	depends on DM_VERITY && DM_UEVENT
> +	---help---
> +	  This option instructs dm-verity to send uevents on error.
> +

Would it cause any problems if we had this feature enabled all the time,
controlled only by DM_UEVENT?

In other words, if we delete DM_VERITY_ERROR_NOTIFY from the upstream patch?

Alasdair

