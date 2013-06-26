Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab3FZIfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:35:15 -0400
Received: from luce.ironicdesign.com ([206.166.194.239]:50000 "EHLO
	luce.ironicdesign.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:35:11 -0400
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2013 04:35:11 EDT
X-AnteSpam-Report: http://antespam.com/missed/8d84cd5c4197be64e6b1cf5ef2cc06b240bf86589ce93b78ee24deeef68e59a7
X-AnteSpam-From: lorenz@badgers.com
X-AnteSpam-Score: -0.199
Message-ID: <20130626102429.98761g4lt34cnnzx@mail.badgers.com>
Date: Wed, 26 Jun 2013 10:24:29 +0200
From: Lorenz Kernel <lorenz@badgers.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, puff65537@bansheeslibrary.com,
        viro@zeniv.linux.org.uk, michael.banken@mathe.stud.uni-erlangen.de,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 2/2 v3] silicom: checkpatch: assignments in if
 conditions
References: <20130618183212.GA8182@kroah.com>
 <1371631444-27789-1-git-send-email-lorenz@badgers.com>
 <20130624231400.GA17306@kroah.com>
In-Reply-To: <20130624231400.GA17306@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.9)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH <gregkh@linuxfoundation.org>:

> On Wed, Jun 19, 2013 at 10:44:04AM +0200, Lorenz Haspel wrote:
>> Fixes checkpatch error:
>> There were assignments in if conditions, so I extracted them.
>>
>> Signed-off-by: Lorenz Haspel <lorenz@badgers.com>
>> Signed-off-by: Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>
>> ---
>> v2: removed some buggy extra lines and fixed white space issues
>> v3: fixed some more extra lines
>
> This patch doesn't apply at all to my tree :(
>
> greg k-h
>

This patch doesn't apply, because Chad Williamson already sent a patch  
fixing the problem.
His patch is already in next-tree, so my patch is not longer necessary.

Lorenz Haspel



----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program,
part of the Horde framework and provided by HomeFreeMail.com.



