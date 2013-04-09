Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937179Ab3DIQuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:50:21 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34007 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934679Ab3DIQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:50:19 -0400
Message-ID: <516446C7.8080802@intel.com>
Date: Tue, 09 Apr 2013 17:50:15 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Chainsaw efivars.c
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <516440F5.7040904@zytor.com>
In-Reply-To: <516440F5.7040904@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 17:25, H. Peter Anvin wrote:
> On 04/04/2013 05:18 AM, Matt Fleming wrote:
>> From: Matt Fleming <matt.fleming@intel.com>
>>
>> drivers/firmware/efivars.c has grown pretty large and is ~2K lines.
>>
> 
> Hi Matt,
> 
> Are you expecting me or Matt G. to take this one?

I was going to send it to you in a pull request once it had been
reviewed. It's a pretty invasive change and I was trying to avoid
breaking drivers/firmware/google in particular. I don't think it's
suitable for merging for v3.10, unless Mike and the pstore folks are
happy with it (and make it known fairly soon).

