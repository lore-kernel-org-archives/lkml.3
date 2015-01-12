Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbbALT5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:57:23 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:49826 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbbALT5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:57:22 -0500
MIME-Version: 1.0
In-Reply-To: <54B42664.1080302@windriver.com>
References: <1421091900-19249-1-git-send-email-computersforpeace@gmail.com>
	<54B42664.1080302@windriver.com>
Date: Mon, 12 Jan 2015 11:57:21 -0800
Message-ID: <CAN8TOE-KQCxvF7e8y6WVs-v33_AOVwTLc38tbPk7eiN+doL-YQ@mail.gmail.com>
Subject: Re: [PATCH] kgdb: fix potential out-of-bounds access
From: Brian Norris <computersforpeace@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:54 AM, Jason Wessel
<jason.wessel@windriver.com> wrote:
> This is actually already fixed a different way in the kgdb-next:
>
> https://git.kernel.org/cgit/linux/kernel/git/jwessel/kgdb.git/commit/?h=kgdb-next&id=c7d9ebf81c456dc185c8eae9e293bfdccf2a65f5

Great. Thanks for the quick response.

Brian
