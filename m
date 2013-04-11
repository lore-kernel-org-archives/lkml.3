Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3DKHVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:21:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60048 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab3DKHVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <87r4ih5ymf.fsf@ashishki-desk.ger.corp.intel.com>
References: <1365627935-17561-1-git-send-email-silviupopescu1990@gmail.com>
	<87r4ih5ymf.fsf@ashishki-desk.ger.corp.intel.com>
Date: Thu, 11 Apr 2013 10:21:10 +0300
Message-ID: <CAPWTe+LKYy3Yd0hVAbpBV=9O3jirTN3_yduP7sXfgg6q=QuwYA@mail.gmail.com>
Subject: Re: [PATCH] drivers: usb: chipidea: convert to devm_ioremap_resource()
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:12 AM, Alexander Shishkin
<alexander.shishkin@linux.intel.com> wrote:
> That's cool, but your chipidea patches have to be based off of
> ci-for-greg branch of the chipidea tree [1] or at least usb-next branch
> of Greg's usb.git [2].
>
> [1] git://github.com/virtuoso/linux-ci.git
> [2] git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git

Thanks for the tip. I see that both trees use devm_ioremap_resource().
I'll remember to check them next time I have a patch.

--
Silviu
