Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3LZBzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 20:55:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38695 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477Ab3LZBzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 20:55:43 -0500
Message-ID: <52BB8C8F.1020606@zytor.com>
Date: Wed, 25 Dec 2013 17:55:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, matt@console-pimps.org
CC: greg@kroah.com, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: split efi systab in sysfs
References: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
In-Reply-To: <20131226015308.GA3750@dhcp-16-126.nay.redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2013 05:53 PM, Dave Young wrote:
> Hi, Matt and Peter
> 
> Currently /sys/firmware/efi/systab contains multi-lines for efi systab
> entries. As previous discussion with Greg, this is not a good in sysfs.
> I wonder if there's other users for this file except kexec-tools.
> 
> If kexec-tools is the only user, maybe I can split it as several files.
> In kexec-tools just use /sys/firmware/efi/"$entry_name" and if $entry_name
> does not exist then switch to old systab file. 
> 

Yes, the sysfs standard is "one entry per datum".  I have no idea about
who the user(s) might be, though.

	-hpa


