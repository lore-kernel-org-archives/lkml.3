Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3I3C7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 22:59:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59413 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab3I3C7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 22:59:08 -0400
Message-ID: <5248E8C2.2000108@zytor.com>
Date: Sun, 29 Sep 2013 19:58:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Dave Jones <davej@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fix apparent cut-n-paste mistake in Dell reboot workaround.
References: <20130925001344.GA13554@redhat.com> <5245E7B1.2000408@zytor.com> <20130930025733.GA21361@srcf.ucam.org>
In-Reply-To: <20130930025733.GA21361@srcf.ucam.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 07:57 PM, Matthew Garrett wrote:
> On Fri, Sep 27, 2013 at 03:16:49PM -0500, H. Peter Anvin wrote:
>>
>> It really is starting to feel like *ALL* Dell machines need reboot=pci?
> 
> Now that ACPI is default, I'd be surprised if any of them do.
> 

Look at the stream of Dell machines we're still getting reboot bug
reports for...

	-hpa

