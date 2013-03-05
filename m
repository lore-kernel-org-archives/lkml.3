Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab3CEKBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 05:01:08 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35819 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEKBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 05:01:06 -0500
Message-ID: <5135C25E.9060507@suse.cz>
Date: Tue, 05 Mar 2013 11:01:02 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, e1000-devel@lists.sourceforge.net,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
References: <2293454.v8QRHr8txR@vostro.rjw.lan> <20130203144656.GB5844@pd.tnic> <20130214143905.GC5700@pd.tnic> <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com> <20130214191234.GH5700@pd.tnic> <511DF7B4.8060504@openvz.org> <20130215091641.GA14387@pd.tnic> <20130304215056.GG22274@pd.tnic> <CAErSpo7Fj3zOp0S9kFrZBCe5u9r6kJUNyx+parGfoq52gWD3XQ@mail.gmail.com> <5135BDF9.3080102@suse.cz> <20130305095821.GC4881@pd.tnic>
In-Reply-To: <20130305095821.GC4881@pd.tnic>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 10:58 AM, Borislav Petkov wrote:
> Rafael, what's the state of those patches here:
> https://lkml.org/lkml/2013/2/4/185, are they ready to be tested or you
> still have issues with them?

Note there is a resend version:
https://lkml.org/lkml/2013/2/25/3

with a note from Jeff Kirsher:
I have added this patch to my e1000e patch queue.

thanks,
-- 
js
suse labs
