Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3FNXCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:02:01 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:57797 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751294Ab3FNXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:02:00 -0400
Message-ID: <51BBA0E4.6030602@hurleysoftware.com>
Date: Fri, 14 Jun 2013 19:01:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ross Lagerwall <rosslagerwall@gmail.com>
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        linux-serial@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty/vt: Return EBUSY if deallocating VT1 and it is busy
References: <20130614213543.GA1896@kroah.com> <1371248665-1176-1-git-send-email-rosslagerwall@gmail.com>
In-Reply-To: <1371248665-1176-1-git-send-email-rosslagerwall@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 06:24 PM, Ross Lagerwall wrote:
> Commit 421b40a6286e ("tty/vt: Fix vc_deallocate() lock order") changed
> the behavior when deallocating VT 1.  Previously if trying to
> deallocate VT1 and it is busy, we would return EBUSY.  The commit
> changed this to return 0 (success).
>
> This commit restores the old behavior.
>
> Signed-off-by: Ross Lagerwall <rosslagerwall@gmail.com>

Thanks.

Acked-by: Peter Hurley <peter@hurleysoftware.com>

