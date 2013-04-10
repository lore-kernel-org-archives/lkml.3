Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936689Ab3DJIgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:36:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762735Ab3DJIgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:36:05 -0400
Message-ID: <51652473.4010902@suse.cz>
Date: Wed, 10 Apr 2013 10:36:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Christopher Li <sparse@chrisli.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] kbuild: avoid some unnecessary rebuild
References: <CANeU7QkMd_evQrJL1Otp3j3CR9FAXSXO9VOKSFmESkWPZNMkEA@mail.gmail.com> <20130317215812.GA23103@merkur.ravnborg.org> <CANeU7Q=uQe7euVnrKExLg0yb1mDJm8NFoFzTqnTn1Gayf69gnA@mail.gmail.com>
In-Reply-To: <CANeU7Q=uQe7euVnrKExLg0yb1mDJm8NFoFzTqnTn1Gayf69gnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.3.2013 23:08, Christopher Li wrote:
> On Sun, Mar 17, 2013 at 2:58 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> We got no patch - just some git help stuff.
>> Seems you mistyped somthing..
>>
> 
> Oops, sorry about that. I reattach the patch here.

Can you send a patch that only fixes scripts/mod? The EFI_STUB rebuild
has been fixed differently in the x86 tree (where such fixes should be
sent anyway).

Thanks,
Michal
