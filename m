Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaK0VKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:10:43 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:58719 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaK0VKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:10:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141127210521.GE23012@1wt.eu>
References: <1416429531-11088-1-git-send-email-marius.gorski@gmail.com>
	<1416429531-11088-5-git-send-email-marius.gorski@gmail.com>
	<20141126215801.GA32756@kroah.com>
	<20141127132657.GA12298@firebird>
	<20141127152417.GB23247@kroah.com>
	<20141127155706.GB24149@kroah.com>
	<20141127195054.GA14536@firebird>
	<20141127210521.GE23012@1wt.eu>
Date: Thu, 27 Nov 2014 19:10:40 -0200
Message-ID: <CAOMZO5D4gSQGdQwJZq4y-7CfUbz=ZTsrDDvmHZX136jFpHK67w@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] staging: panel: Use defined value or checking
 module params state
From: Fabio Estevam <festevam@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Mariusz Gorski <marius.gorski@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 7:05 PM, Willy Tarreau <w@1wt.eu> wrote:

> Mariusz, for people who have to parse hundreds to thousands of e-mails
> a day, dealing with non-trivial operation modes like this is never easy.
>
> I think (I'll let Greg suggest what he prefers) that the most reliable
> thing to do *right now* is to rebase your tree on top of Greg's staging
> tree, and you send the resulting series (what you apply *after* staging)

Actually 'staging-testing' branch would be better:
https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/log/?h=staging-testing&ofs=100

There are 4 patches from Mariusz already applied there.
