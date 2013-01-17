Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3AQSy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:54:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43553 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab3AQSyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:54:55 -0500
Message-ID: <50F848B3.9050800@canonical.com>
Date: Thu, 17 Jan 2013 13:53:39 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, pkondeti@codeaurora.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
References: <50F84441.8080300@canonical.com> <20130117185156.GK13292@decadent.org.uk>
In-Reply-To: <20130117185156.GK13292@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2013 01:51 PM, Ben Hutchings wrote:
> On Thu, Jan 17, 2013 at 01:34:41PM -0500, Joseph Salisbury wrote:
>> Hello,
>>
>> Please consider reverting commit
>> 3d037774b42ed677f699b1dce7d548d55f4e4c2b in mainline as well as in
>> the current stable releases.  It was included upstream as of
>> v3.6-rc6.  This commit introduced a regression, described in the
>> following bug report:
>>
>> http://bugs.launchpad.net/bugs/1088733
>>
>> Reverting commit 3d037774b42ed677f699b1dce7d548d55f4e4c2b in the
>> v3.2 kernel has been confirmed to resolve the aforementioned bug.
>   
> If it's wrong in mainline then the revert needs to be done there
> and cc'd to stable.  We only revert directly in stable branches if
> the revert is not appropriate in mainline.
>
> Ben.
>
Hi Ben,

Understood.  Thanks for the feedback.  I'll resend as a patch to mainline.

Thanks,

Joe
