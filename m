Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbaGXQVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:21:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45634 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGXQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 12:21:08 -0400
Message-ID: <53D13255.4030004@oracle.com>
Date: Thu, 24 Jul 2014 12:20:37 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: stern@rowland.harvard.edu, mail@beyermatthias.de, hdegoede@redhat.com,
        sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Sasha Levin <sashal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb-core: Revert "usb-core: Remove Fix mes in file hcd.c"
References: <1406120170-22983-1-git-send-email-sasha.levin@oracle.com> <20140723164910.GA8319@kroah.com> <53D106C9.8070803@oracle.com> <20140724160447.GC14956@kroah.com>
In-Reply-To: <20140724160447.GC14956@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 12:04 PM, Greg KH wrote:
>> If you add a revert and leave the original broken commit in, wouldn't it cause issues
>> > for anyone trying to bisect a build breakage?
> Yes it does.
> 
> I can not rebase my public trees, nor should any other kernel
> maintainer.  This has been true for _many_ years.

This isn't the case with -mm, for example, where the tree does get edited
quite often.

What stops you from editing it even if people are working on it? 'git pull --rebase'
will dtrt for both the ff and the non-ff case, where the non-ff case would have happen
either way if those people kept tracking your -next tree.


Thanks,
Sasha
