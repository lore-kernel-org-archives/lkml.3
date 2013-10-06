Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3JFU3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 16:29:14 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50252 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3JFU3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 16:29:12 -0400
MIME-Version: 1.0
In-Reply-To: <20131004161226.GA22784@srcf.ucam.org>
References: <1380820383-23336-1-git-send-email-felipe.contreras@gmail.com>
	<20131004161226.GA22784@srcf.ucam.org>
Date: Sun, 6 Oct 2013 15:29:10 -0500
Message-ID: <CAMP44s0tqKBgUTzFnbTMqDVVWLcaDC5VKd9mq_w+T_Yu19KXqQ@mail.gmail.com>
Subject: Re: [PATCH] acpi: update win8 OSI blacklist
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 11:12 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Oct 03, 2013 at 12:13:03PM -0500, Felipe Contreras wrote:
>> More people have reported they need this for their machines to work
>> correctly.
>
> Can you add a comment to each indicating why they're being added so we
> can easily remove them again once the problem is fixed?

Because that's what users report:
https://bugzilla.kernel.org/show_bug.cgi?id=60682

-- 
Felipe Contreras
