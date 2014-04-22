Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaDVO2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:28:13 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:57131 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525AbaDVO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:28:04 -0400
Message-ID: <53567C70.2080008@lwfinger.net>
Date: Tue, 22 Apr 2014 09:28:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        navin patidar <navin.patidar@gmail.com>
CC: devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] staging: rtl8188eu: Remove _ReadLEDSetting() function.
References: <1397983638-10752-1-git-send-email-navin.patidar@gmail.com> <1397983638-10752-3-git-send-email-navin.patidar@gmail.com> <20140422101101.GG26890@mwanda> <CAPV97yd4THZOcV8CGJJ+d5otsP9pvOO5A9SgjFXLLf+sSkoN=w@mail.gmail.com> <20140422141417.GM26890@mwanda>
In-Reply-To: <20140422141417.GM26890@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 09:14 AM, Dan Carpenter wrote:
> On Tue, Apr 22, 2014 at 07:31:50PM +0530, navin patidar wrote:
>> Hi dan
>>
>> it's just a cleanup patch and i also tested all patches of this patch
>> series on the hardware (TP-LINK  TL-WN723N).
>> my mistake i should have added "Tested-by" tag for all patches.
>>
>> Tested-by: navin patidar <navin.patidar@gmail.com>
>
> No no.  It's not necesary to add a tested by to everything.  It was just
> something I was curious about.  The patches looked ok.  If you hadn't
> tested them I would review them a second time more carefully.

To me, the opposite case is true. If you have not tested, then you need to 
explicitly state "compile tested only" in the commit message. Without saying 
that, your signed-off-by is implying that you have tested, as well as declaring 
that you own the copyright to the material.

Larry

