Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbbAZKHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:07:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529AbbAZKH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:07:29 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com
Subject: Re: [PATCH RESEND 1/5] Tools: hv: add mising fcopyd to the Makefile
References: <1420870690-2223-1-git-send-email-kys@microsoft.com>
	<1420870735-2265-1-git-send-email-kys@microsoft.com>
	<20150125133433.GA2708@kroah.com>
Date: Mon, 26 Jan 2015 11:07:13 +0100
In-Reply-To: <20150125133433.GA2708@kroah.com> (Greg KH's message of "Sun, 25
	Jan 2015 21:34:33 +0800")
Message-ID: <87ppa1g8j2.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Fri, Jan 09, 2015 at 10:18:51PM -0800, K. Y. Srinivasan wrote:
>> From: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> fcopyd in missing in the Makefile, add it there.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
>> ---
>>  tools/hv/Makefile |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> This patch fails to apply :(

The was a mid-air collision with Matej's 'tools: hv: Makefile: Add
hv_fcopy_daemon to Makefile' patch, feel free to drop this one.

Sorry for the inconvenience,

-- 
  Vitaly
