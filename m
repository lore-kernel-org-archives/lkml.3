Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab3A3LIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:08:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3A3LIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:08:06 -0500
MIME-Version: 1.0
In-Reply-To: <s5hd2wnrlgl.wl%tiwai@suse.de>
References: <1359470814-7993-1-git-send-email-tiwai@suse.de>
	<1359470814-7993-2-git-send-email-tiwai@suse.de>
	<CACVXFVOf4LZD+qVcqS9yBtvNZCRF=LMpR5BKuXby3Z8dfB+Vzw@mail.gmail.com>
	<s5hpq0nw35i.wl%tiwai@suse.de>
	<CACVXFVN9JNe6US655hh3cNpKyJFdWrLEYOOOdnk97_5bFmZYxw@mail.gmail.com>
	<s5hfw1jrmhn.wl%tiwai@suse.de>
	<CACVXFVNmhpfHgM4BVMDi3tffN4ajinUqnZD7c3fPvTL26EDDRA@mail.gmail.com>
	<s5hd2wnrlgl.wl%tiwai@suse.de>
Date: Wed, 30 Jan 2013 19:08:03 +0800
Message-ID: <CACVXFVP6U0CmVZNUqh9eiQ0qBqXdqvr0EVr9jajJby+9mqJ3dg@mail.gmail.com>
Subject: Re: [PATCH 1/4] firmware: Refactoring for splitting user-mode helper code
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 6:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 30 Jan 2013 18:50:05 +0800,
> Ming Lei wrote:
>>
>> On Wed, Jan 30, 2013 at 6:31 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >
>> > But it's supposed to be cached, no?
>>
>> Generally it will be cached, but some crazy devices might come as new
>> device during resume, so we still need to handle the situation.
>
> In that case, shouldn't we simply return an error instead of
> usermodehelper lock (at least for direct loading)?

The check depends on usermodehelper_read_trylock now, is there
other simpler way to do the check?

Thanks,
--
Ming Lei
