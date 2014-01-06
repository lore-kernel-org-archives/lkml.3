Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaAFQrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:47:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbaAFQri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:47:38 -0500
Message-ID: <52CADE19.9010607@redhat.com>
Date: Mon, 06 Jan 2014 11:47:21 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Edel Maks <edelmaks@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] HID: multitouch: add support of other generic collections
 in hid-mt
References: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com> <1387470191-9725-4-git-send-email-benjamin.tissoires@redhat.com> <52B5F96D.9050400@euromail.se> <alpine.LNX.2.00.1401031056000.14951@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1401031056000.14951@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/14 04:56, Jiri Kosina wrote:
> On Sat, 21 Dec 2013, Henrik Rydberg wrote:
> 
>>> The ANTEC Touch Pad is a device which can switch from a multitouch
>>> touchpad to a mouse. It thus presents several generic collections which
>>> are currently ignored by hid-multitouch. Enable them by using the generic
>>> protocol. Adding also a suffix for them depending on their application.
>>
>> In what way does this and the preceeding patches differ from "else if (is_pen ||
>> export_all_inputs)"? Adding a functional pattern which then is converted to a
>> generic case, such that the usual branching is bound to occur anyways, seems
>> unnecessary.
> 
> Benjamin,
> 
> did you have chance to do any followup work on this?
> 
> If this is to go into 3.14, it's the time to have the thing finalized.
> 

Hi Jiri,

well, I'm still not sure what to answer to address Henrik's comments. I
will work on that later in the week I think, but currently I am focusing
on hid-logitech-dj and others, which is rather time consuming.

I think Maks is fine with the current status (he still have to use a
backport due to an arm platform), so let's skip this for 3.15.

Cheers,
Benjamin

