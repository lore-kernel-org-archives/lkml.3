Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaJOJSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 05:18:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54750 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaJOJSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 05:18:14 -0400
Date: Wed, 15 Oct 2014 11:18:08 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Subject: Re: [PATCH v2 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141015091808.GB5300@localhost.localdomain>
References: <1413362404-16284-1-git-send-email-huishao@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413362404-16284-1-git-send-email-huishao@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 01:40:04AM -0700, Thomas Shao wrote:
> In current hyper-v time sync service,it only gets the initial clock time
> from the host. It didn't process the following time samples. This change
> introduced a module parameter called host_time_sync. If it is set to true,
> the guest will periodically sychronize it's time with the host clock using
> host time sample. By default it is disabled, because we still recommend
> user to configure NTP for time synchronization.
> 
> Signed-off-by: Thomas Shao <huishao@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---

Um, what changed in V2?

Thanks,
Richard
