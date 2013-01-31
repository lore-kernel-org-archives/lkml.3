Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3AaQRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:17:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3AaQRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:17:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130131161543.GA25700@kroah.com>
References: <1359627237-7069-1-git-send-email-tiwai@suse.de>
	<20130131161543.GA25700@kroah.com>
Date: Fri, 1 Feb 2013 00:17:33 +0800
Message-ID: <CACVXFVNvSSmwxLnCnTKyHiUN40dt1GDG2VarEzouqUkqz0rR1g@mail.gmail.com>
Subject: Re: [PATCH 0/4] firmware: Make user-mode helper optional (v5)
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 12:15 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jan 31, 2013 at 11:13:53AM +0100, Takashi Iwai wrote:
>> Hi,
>>
>> this is a series of revised patches for making the user-mode helper
>> call in the firmware loader optional.  Hopefully all things settled
>> down now.
>>
>> v4->v5: fix invalid call of usermodehelper_unlock()
>
> Yeah!  I was working on doing just this right as you sent this series
> in.  I'll take your patches instead of mine, you did all of the hard
> work here, thanks :)
>
> Ming, any objection to me taking them?

No objections, and I have reviewed the patch set and acked them all.

Thanks,
--
Ming Lei
