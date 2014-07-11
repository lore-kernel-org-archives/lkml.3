Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaGKPHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:07:03 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54584 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301AbaGKPHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:07:00 -0400
Message-ID: <53BFFD90.5010405@hurleysoftware.com>
Date: Fri, 11 Jul 2014 11:06:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty.current tree
References: <20140711112108.7631911b@canb.auug.org.au>
In-Reply-To: <20140711112108.7631911b@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 09:21 PM, Stephen Rothwell wrote:
> Hi Greg,
>
> After merging the tty.current tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
[...]
> Caused by commit c557d392fbf5 ("serial: Test for no tx data on tx
> restart").  That can't have been build tested :-(

Sorry about that. I don't have a full cross-compiler setup for
build testing. Looks like that's something I'm going to have to add.

Regards,
Peter Hurley
