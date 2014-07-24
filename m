Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210AbaGXQEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:04:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59334 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbaGXQEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:04:10 -0400
Message-ID: <53D12E74.5070508@wwwdotorg.org>
Date: Thu, 24 Jul 2014 10:04:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 04/15] Input: atmel_mxt_ts - implement device tree support
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <1404399697-26484-5-git-send-email-nick.dyer@itdev.co.uk> <53D02AF8.5000100@wwwdotorg.org> <53D121DE.8070401@itdev.co.uk>
In-Reply-To: <53D121DE.8070401@itdev.co.uk>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 09:10 AM, Nick Dyer wrote:
> On 23/07/14 22:36, Stephen Warren wrote:
>> Hmm. It looks like the version of this patch that was actually applied
>> varies quite a bit from what was posted, in particular in the
>> implementation and call site of mxt_parse_dt(). It'd be nice if the
>> commit log had been adjusted to mention this, so it didn't look like *I*
>> caused all those compile errors and warnings that the 0-day builder just
>> found:-(
> 
> Apologies for my part in this. It doesn't help that this patch went through
> several revisions. Is there a best practice for when to remove
> signed-off-by or change authorship documented anywhere?

My comment was more directed at the diff between what you posted and
what was applied.

I believe the usual practice is:

* If completely re-writing a patch using another as inspiration, change
the author and credit them in free-form text, or perhaps with a
Based-on-work-by: tag.

* If generally keeping the patch, but just changing a few things, make a
note of it in between the s-o-b lines, e.g.:

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
[assign directly to pdata->t19_keymap to avoid a temporary, description
of other changes ...]
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
