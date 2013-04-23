Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3DWEn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:43:28 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:50975 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3DWEn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130326014733.GA6496@kroah.com>
References: <1364261482-19160-1-git-send-email-dhobsong@igel.co.jp>
	<20130326014733.GA6496@kroah.com>
Date: Tue, 23 Apr 2013 10:13:26 +0530
Message-ID: <CAK9yfHw1o8+zunwK-NbMsbGdgOmpo8qGk8YjjiTLCsj0BhZehw@mail.gmail.com>
Subject: Re: [PATCH] drivers: uio: Fix UIO device registration failure
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 07:17, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Mar 26, 2013 at 10:31:22AM +0900, Damian Hobson-Garcia wrote:
>> Until recently uio_get_minor() returned 0 for success and
>> a negative value on failure.  This became non-negative for suceess and
>> negative for failure.  Restore the original return value spec so that we can
>> successfully initialize UIO devices with a non-zero minor device
>> number.
>>
>> Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
>> ---
>>  drivers/uio/uio.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> Hans, don't you have a bunch of uio patches queued up for me?  I've been
> ignoring them, thinking you are collecting them, is this not true?

Greg, there isn't any response from Hans regarding the UIO patches.
Would you be picking them instead?

-- 
With warm regards,
Sachin
