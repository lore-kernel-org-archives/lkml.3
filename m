Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3LJDxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:53:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64996 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3LJDxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:53:19 -0500
MIME-Version: 1.0
In-Reply-To: <20131209013019.GA18048@kroah.com>
References: <1386455752-17600-1-git-send-email-preetamjdsouza@gmail.com>
	<20131209013019.GA18048@kroah.com>
Date: Mon, 9 Dec 2013 19:53:19 -0800
Message-ID: <CABYqeiVRqoAZAH+9_=mn=5+fMPHtehTK7zyAagNwuuAHC_UtZA@mail.gmail.com>
Subject: Re: [PATCH] Staging: android: fix parantheses coding style issue in alarm-dev.c
From: "Preetam D'Souza" <preetamjdsouza@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg--I'm working against Linus' latest tree on
https://github.com/torvalds/linux.git ... which tree should I be using
for the updated code?

Thanks!
Preetam

On Sun, Dec 8, 2013 at 5:30 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Dec 07, 2013 at 02:35:52PM -0800, Preetam D'Souza wrote:
>> This patch fixes an unecessary return statement parantheses error
>> found in alarm-dev.c by the checkpatch.pl tool -- alarm-dev.c now has
>> no more errors/warnings!
>>
>> Signed-off-by: Preetam D'Souza <preetamjdsouza@gmail.com>
>> ---
>>  drivers/staging/android/alarm-dev.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> This was already fixed a while ago, what tree are you working against?
>
> sorry, I can't apply this again.
>
> greg k-h
